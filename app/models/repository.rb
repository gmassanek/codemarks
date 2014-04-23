class Repository < Resource
  hstore_indexed_attr :title, :description, :forks_count, :stargazers_count, :watchers_count, :language, :owner_login

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

  def url
    "https://github.com/#{owner_login}/#{title}"
  end
end
