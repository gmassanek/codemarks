Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :provider, consumer_key, consumer_secret
  provider :twitter, ENV['CODEMARK_TWITTER_KEY'], ENV['CODEMARK_TWITTER_SECRET']
  provider :github, "17d564cb5975e018dd77", "e98387e2eb75b7a52f970d91e7e7f053220dc9e6"
end

