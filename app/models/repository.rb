class Repository < Resource
  hstore_indexed_attr :title, :description, :language, :owner_login, :pushed_at, :repo_created_at
  hstore_attr :owner_avatar_url, :owner_gravatar_id, :fork, :size, :forks_count, :watchers_count

  def self.create_from_url(url)
    return unless matches = url.match(/github\.com\/(?<name>[\w-]*)\/(?<title>[\w-]*)$/)
    name = matches['name']
    title = matches['title']

    find_by_login_and_repo(name, title) || new_from_login_and_repo(name, title)
  end

  def self.new_from_login_and_repo(login, title)
    repo = Repository.new(:owner_login => login, :title => title)
    repo.refresh_remote_data!
    repo
  end

  def self.find_by_login_and_repo(login, repo)
    has_owner_login(login).has_title(repo).first
  end

  def url
    "https://github.com/#{owner_login}/#{title}"
  end

  def suggested_topics
    title_topic = Topic.search_for(self.title) || Topic.create!(:title => self.title.downcase) if self.title
    language_topic = Topic.search_for(self.language) || Topic.create!(:title => self.language.downcase) if self.language
    description_topics = Topic.where(:title => Tagger.tag(self.description)) if self.description
    [title_topic, language_topic, description_topics].flatten.compact.uniq.first(Tagger::TAG_SUGGESTION_LIMIT)
  end

  def refresh_remote_data!
    return false unless refresh_url

    request = Faraday.get(refresh_url)
    return false unless request.success?

    json = JSON.parse(request.body)
    update_attributes({
      :description => json['description'],
      :fork => json['fork'],
      :forks_count => json['forks_count'],
      :language => json['language'],
      :owner_avatar_url => json['owner']['avatar_url'],
      :owner_gravatar_id => json['owner']['gravatar_id'],
      :owner_login => json['owner']['login'],
      :pushed_at => json['pushed_at'],
      :repo_created_at => json['created_at'],
      :size => json['size'],
      :title => json['name'],
      :watchers_count => json['watchers_count']
    })
  end

  def refresh_url
    return unless owner_login && title

    "https://api.github.com/repos/#{owner_login}/#{title}?client_id=#{ENV['CODEMARK_GITHUB_KEY']}&client_secret=#{ENV['CODEMARK_GITHUB_SECRET']}"
  end
end
