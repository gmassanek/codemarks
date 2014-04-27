class Repository < Resource
  hstore_indexed_attr :title, :description, :forks_count, :stargazers_count, :watchers_count, :language, :owner_login

  def self.create_from_url(url)
    return unless matches = url.match(/github\.com\/(?<name>[\w-]*)\/(?<repo>[\w-]*)$/)
    name = matches['name']
    repo = matches['repo']

    if repository = (find_by_login_and_repo(name, repo) || new_from_login_and_repo(name, repo))
      repository.save!
      repository
    end
  end

  def self.new_from_login_and_repo(login, repo)
    request = Faraday.get("https://api.github.com/repos/#{login}/#{repo}?client_id=#{ENV['CODEMARK_GITHUB_KEY']}&client_secret=#{ENV['CODEMARK_GITHUB_SECRET']}")
    if request.success?
      json = JSON.parse(request.body)
      data = {
        :title => json['name'],
        :description => json['description'],
        :forks_count => json['forks_count'],
        :stargazers_count => json['stargazers_count'],
        :watchers_count => json['watchers_count'],
        :language => json['language'],
        :owner_login => json['owner']['login']
      }
      new(data)
    end
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
end
