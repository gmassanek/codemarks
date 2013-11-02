namespace :backfill  do
  desc 'create a StarterLeague Booklist'
  task :booklist => :environment do
    file = File.open('script/src_files/booklist.txt', 'r').read
    file.gsub!(/\r\n?/, "")
    file.gsub!(/\\r\\n?/, "")
    chunked_lines = {}
    person = nil
    file.each_line do |line|
      if new_line = line == "\n"
        person = nil
      else
        line.gsub!(/\n?/, "")
        unless person
          person = line
          chunked_lines[person] = []
        end
        chunked_lines[person] << line
      end
    end

    codemarks = {}
    chunked_lines.each do |name, lines|
      nickname = lines[1]

      data = {
        :nickname => nickname,
        :text_name => name,
        :resources => lines[2..-1].map do |resource_data|
          split_data = resource_data.split(',')
          {
            title: split_data[0],
            url: split_data[1],
            extras: split_data[2..-1]
          }
        end
      }
      codemarks[nickname] = data
    end

    booklist = Topic.find_or_create_by_title('booklist')
    starterleague = Topic.find_or_create_by_title('Starter League')

    codemarks.each do |nickname, data|
      user = User.find_by_nickname(nickname) || User.find_by_nickname('gmassanek')
      p user.nickname

      next unless data[:resources]
      data[:resources].each do |resource_data|
        link = Link.new(:url => resource_data[:url].strip, :author_id => user.id)
        link.load
        description = resource_data[:extras].join(' ').try(&:strip) if resource_data[:extras]

        topics = [booklist, starterleague] | link.tags
        topics = topics | Tagger.tag(description) if description
        topics = topics.reject { |t| ['Amazon', 'Images', 'Width'].include?(t.title) }
        topics = topics.first(4).compact

        cm = Codemark.create({
          :resource_id => link.link_record.id,
          :resource => link.link_record,
          :user_id => user.id,
          :title => resource_data[:title],
          :description => description
        }, {
          :ids => topics.map(&:id)
        })
      end
    end
  end

  desc 'normalize all link_record urls'
  task :normalize_urls => :environment do
    Link.all.each do |link|
      link.update_attributes(:url => Link.normalize(link.url))
    end
  end

  desc 'set all existing codemarks to Link type'
  task :set_to_link_records => :environment do
    Codemark.all.each do |cm|
      cm.update_attributes(:resource_type => 'Link')
    end
  end

  desc 'get snapshots for every link'
  task :snapshot_links => :environment do
    Link.all.each do |link|
      Delayed::Job.enqueue(SnapLinkJob.new(link))
    end
  end

  desc 'verify link click count'
  task :verify_click_count => :environment do
    Link.all.each do |link|
      click_record_count = Click.where(:link_record_id => link.id).count
      next if link.clicks_count == click_record_count
      puts "Updating #{link.url} click count from #{link.clicks_count} to #{click_record_count}"
      link.update_attributes(:clicks_count => click_record_count)
    end
  end

  desc 'dedup users'
  task :dedup_users => :environment do
    nicknames = User.all.group_by(&:nickname)
    nicknames.select! { |n, users| users.count > 1 }
    nicknames.each do |_, users|
      first = users.min_by(&:created_at)
      others = users.reject { |u| u.id == first.id }
      next if others.any? { |u| u.authentications.count > 1 }
      others.each do |user|
        user.authentications.each { |auth| auth.update_attributes(:user_id => first.id) }
        user.clicks.each { |click| click.update_attributes(:user_id => first.id) }
        user.codemarks.each { |cm| cm.update_attributes(:user_id => first.id) }
        user.topics.each { |topic| topic.update_attributes(:user_id => first.id) }
        Comment.where(:author_id => user).each { |comment| comment.update_attributes(:author_id => first.id) }
        if user.authentications.count == 0 && user.clicks.count == 0 &&
          user.codemarks.count == 0 && user.topics.count == 0 &&
          Comment.where(:author_id => user).count == 0
          puts "Removing #{user.nickname}, user ##{user.id}"
          user.destroy
        end
      end
    end
  end

  desc 'load snapshots to DB'
  task :load_snapshots_from_file => :environment do
    snapshots = eval(File.open('/tmp/link_snapshot_array.rb', 'r').read)
    snapshots.each do |snapshot_data|
      link_id = snapshot_data[0]
      url = snapshot_data[1]
      snapshot_url = snapshot_data[2]
      snapshot_id = snapshot_data[3]
      link = Link.find(link_id)
      if link.snapshot_url
        puts "Skipping link #{link.id} because it has a snapshot already"
      end
      if link.url == url
        link.update_attributes(:snapshot_id => snapshot_id, :snapshot_url => snapshot_url)
      else
        puts "Skipping link #{link.id} because #{link.url} != #{url}"
      end
    end
  end

  desc 'removed duplicate links'
  task :remove_dup_links => :environment do
    links = Link.select('url, count(*) as count').group(:url)
    links.select! { |l| l.count.to_i > 1 }
    links.each do |link|
      dup_links = Link.find_all_by_url(link.url)
      first = dup_links.min_by(&:created_at)
      the_rest = dup_links.reject { |link| link.id == first.id }

      the_rest.each do |link|
        puts "De-duping #{link.url}"

        clicks = Click.where(:link_record_id => link.id)
        clicks.each { |c| c.update_attributes(:link_record_id => first.id) }

        codemarks = Codemark.where(:resource_id => link.id)
        codemarks.each { |c| c.update_attributes(:resource_id => first.id) }

        link.destroy
      end
    end
  end

  desc "save link_record.author_id based on first codemark.user"
  task :author_id => :environment do
    target_link_records = Link.find(:all, :conditions => {:author_id => nil})
    codemarks = Codemark.find(:all, :conditions => {:link_record_id => [target_link_records.collect(&:id)]})

    firsts = {}
    codemarks.each do |codemark|
      lr_id = codemark.link_record_id
      first = firsts[lr_id]
      if first && first.created_at < codemark.created_at
        firsts[lr_id] = first
      else
        firsts[lr_id] = codemark
      end
    end

    p firsts.keys.count
    p codemarks.count

    authors = {}
    firsts.each do |link_record_id, first_codemark|
      authors[link_record_id] = first_codemark.user
      Link.find(link_record_id).update_attributes(:author => first_codemark.user)
    end

    p authors

  end

  desc 'removed duplicate topics'
  task :remove_dup_topics => :environment do
    topics = Topic.select('title, count(*) as count').group(:title)
    topics.select! { |l| l.count.to_i > 1 }
    topics.each do |topic|
      dup_topics = Topic.find_all_by_title(topic.title)
      first = dup_topics.min_by(&:created_at)
      the_rest = dup_topics.reject { |topic| topic.id == first.id }

      the_rest.each do |topic|
        puts "De-duping #{topic.title}"

        codemark_topics = CodemarkTopic.where(:topic_id => topic.id)
        codemark_topics.each { |c| c.update_attributes(:topic_id => first.id) }

        topic.destroy
      end
    end
  end

  desc 'clean topics'
  task :clean_topics => :environment do
    topics_to_delete = ['and', 'DELETE', 'or', 'ai', 'austin', 'beer', 'BlueCloth', 'Code Quarterly', 'Coderetreat', 'decent_exposure', 'ffaker', 'Hal Abelson', 'includes', 'migration', 'Socal Media', 'techstars', 'woof', 'XPath']
    topics_to_delete.map { |t| Topic.find_by_title(t).try(:destroy) }

    topics_to_combine = {
      'angularjs' => ['angular'],
      'backbone.js' => ['backbone'],
      'beginner' => ['beginners'],
      'book' => ['Book', 'books'],
      'browsers' => ['browswer'],
      'callbacks' => ['Callback'],
      'Cheatsheet' => ['Cheat Sheet'],
      'client ip' => ['client_ip'],
      'conference-talk' => ['conference-talik'],
      'couchdb' => ['couch-db'],
      'design' => ['desgn', 'Design'],
      'DOM' => ['dom'],
      'elasticsearch' => ['Elastic Search'],
      'emberjs' => ['Ember'],
      'es6' => ['ES6'],
      'examples' => ['Example'],
      'front-end' => ['frontend'],
      'generator' => ['generators '],
      'howto' => ['how-to'],
      'Modules' => ['Module'],
      'MongoDB' => ['Mongo DB'],
      'node.js' => ['nodejs', 'Node.js'],
      'objects' => ['object'],
      'optimizations' => ['Optimization'],
      'R' => ['r '],
      'rubygems' => ['rubygem'],
      'scopes' => ['scope'],
      'screencasts' => ['screencast'],
      'sessions' => ['session'],
      'Startups' => ['Startup'],
      'Statistics' => ['stats'],
      'sync' => ['SYNC'],
      'tips' => ['tip'],
      'Transitions' => ['transition'],
      'tutorials' => ['Tutorial'],
      'unicode' => ['Unicodes'],
      'validations' => ['validation'],
      'Web Server' => ['web-servers'],
      'web developer' => ['web-developers'],
      'developers' => ['developer'],
      'zsh' => ['Zshell'],
      'dry' => ['DRY'],
      'html' => ['Html'],
      'Ruby' => ['ruby'],
      'Ruby on Rails' => ['ruby on rails'],
      'sql' => ['SQL'],
      'testing' => ['Testing'],
      'i18n' => ['i18n']
    }

    topics_to_combine.each do |correct, topics|
      correct_topic = Topic.find_by_title(correct)
      next unless correct_topic

      topics.each do |title|
        topic = Topic.find_by_title(title)
        next unless topic

        puts "De-duping #{topic.title}"

        codemark_topics = CodemarkTopic.where(:topic_id => topic.id)
        codemark_topics.each { |c| c.update_attributes!(:topic_id => correct_topic.id) }

        topic.destroy
      end
    end

    Topic.all.each do |t|
      t.update_attributes(:title => t.title.strip)
    end

    Topic.where('slug LIKE ?', "%--%").each do |t|
      t.update_attributes(:slug => nil)
    end
  end
end

