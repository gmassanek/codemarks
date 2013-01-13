namespace :backfill  do
  desc 'normalize all link_record urls'
  task :normalize_urls => :environment do
    LinkRecord.all.each do |link|
      link.update_attributes(:url => Link.normalize(link.url))
    end
  end

  desc 'set all existing codemark_records to LinkRecord type'
  task :set_to_link_records => :environment do
    CodemarkRecord.all.each do |cm|
      cm.update_attributes(:resource_type => 'LinkRecord')
    end
  end

  desc 'get snapshots for every link'
  task :snapshot_links => :environment do
    LinkRecord.all.each do |link|
      Delayed::Job.enqueue(SnapLinkJob.new(link))
    end
  end

  desc 'verify link click count'
  task :verify_click_count => :environment do
    LinkRecord.all.each do |link|
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
        user.codemark_records.each { |cm| cm.update_attributes(:user_id => first.id) }
        user.topics.each { |topic| topic.update_attributes(:user_id => first.id) }
        Comment.where(:author_id => user).each { |comment| comment.update_attributes(:author_id => first.id) }
        if user.authentications.count == 0 && user.clicks.count == 0 &&
          user.codemark_records.count == 0 && user.topics.count == 0 &&
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
      link = LinkRecord.find(link_id)
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
    links = LinkRecord.select('url, count(*) as count').group(:url)
    links.select! { |l| l.count.to_i > 1 }
    links.each do |link|
      dup_links = LinkRecord.find_all_by_url(link.url)
      first = dup_links.min_by(&:created_at)
      the_rest = dup_links.reject { |link| link.id == first.id }

      the_rest.each do |link|
        puts "De-duping #{link.url}"

        clicks = Click.where(:link_record_id => link.id)
        clicks.each { |c| c.update_attributes(:link_record_id => first.id) }

        codemarks = CodemarkRecord.where(:resource_id => link.id)
        codemarks.each { |c| c.update_attributes(:resource_id => first.id) }

        link.destroy
      end
    end
  end

  desc "save link_record.author_id based on first codemark.user"
  task :author_id => :environment do
    target_link_records = LinkRecord.find(:all, :conditions => {:author_id => nil})
    codemarks = CodemarkRecord.find(:all, :conditions => {:link_record_id => [target_link_records.collect(&:id)]})

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
      LinkRecord.find(link_record_id).update_attributes(:author => first_codemark.user)
    end

    p authors

  end
end

