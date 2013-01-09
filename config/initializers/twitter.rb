Twitter.configure do |config|
  config.consumer_key = ENV['CODEMARK_TWEET_KEY']
  config.consumer_secret = ENV['CODEMARK_TWEET_SECRET']
  config.oauth_token = ENV['CODEMARK_TWEET_ACCESS_KEY']
  config.oauth_token_secret = ENV['CODEMARK_TWEET_ACCESS_SECRET']
end
