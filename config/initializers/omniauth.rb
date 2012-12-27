Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :provider, consumer_key, consumer_secret
  Rails.logger.info 'API KEYS AT STARTUP'
  Rails.logger.info 'twitter_key: ' + ENV['CODEMARK_TWITTER_KEY'].to_s
  Rails.logger.info 'twitter_secret: ' + ENV['CODEMARK_TWITTER_SECRET'].to_s
  Rails.logger.info 'github_secret: ' + ENV['CODEMARK_GITHUB_KEY'].to_s
  Rails.logger.info 'github_secret: ' + ENV['CODEMARK_GITHUB_SECRET'].to_s
  provider :twitter, ENV['CODEMARK_TWITTER_KEY'], ENV['CODEMARK_TWITTER_SECRET']
  provider :github, ENV['CODEMARK_GITHUB_KEY'], ENV['CODEMARK_GITHUB_SECRET']
end

