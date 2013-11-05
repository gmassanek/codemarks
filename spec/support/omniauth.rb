OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:twitter, {
  :uid => '260598813',
  :info => {
    :name => "Geoff Massanek",
    :image => "https://si0.twimg.com/profile_images/1269676102/twit2_bigger.jpg",
    :location => "Chicago, IL",
    :description => "The baddest twitter monster on the planet",
    :nickname => "gmassanek"
  }
})

OmniAuth.config.add_mock(:github, {
  :uid => '343891',
  :info => {
    :name => "Github Monster",
    :image => "http://www.gravatar.com/avatar/58dbba1be3de0ccf3a495e978bdcb220.png",
    :location => "Chicago, IL",
    :nickname => "gmassanek"
  }
})
