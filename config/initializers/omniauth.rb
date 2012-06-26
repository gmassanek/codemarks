Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :provider, consumer_key, consumer_secret
  provider :twitter, ENV['CODEMARK_TWITTER_KEY'], ENV['CODEMARK_TWITTER_SECRET']
  provider :github, ENV['CODEMARK_GITHUB_KEY_2'], ENV['CODEMARK_GITHUB_SECRET_2']
  provider :github, ENV['CODEMARK_GITHUB_KEY_1'], ENV['CODEMARK_GITHUB_SECRET_1']
end

