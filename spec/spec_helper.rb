ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

include Exceptions
include OOPs

TEST_BROKEN = false

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
RSpec::Matchers::OperatorMatcher.register(ActiveRecord::Relation, '=~', RSpec::Matchers::MatchArray)

RSpec.configure do |config|
  if TEST_BROKEN == false
    config.filter_run_excluding :broken => true
  end

  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
end

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:twitter, {
  :uid => '12345',
  :nickname => 'zapnap'
})
OmniAuth.config.add_mock(:github, {
  :uid => '234234',
  :nickname => 'zapnap'
})

def simulate_signed_in
  visit '/auth/twitter'
  @user = User.last
end

def simulate_github_signed_in
  visit '/auth/github'
  @user = User.last
end

def authenticated_user
  auth = Fabricate.build(:authentication)
  user = auth.user
end

#OmniAuth.config.add_mock(:twitter, {
#  :uid => '987877',
#  :name => "Twitter Monster",
#  :profile_image_url => "http://a3.twimg.com/profile_images/689684365/api_normal.png",
#  :location => "San Francisco, CA",
#  :url => "http://dev.twitter.com",
#  :followers_count => 123411,
#  :listed_count => 32,
#  :description => "The baddest twitter monster on the planet",
#  :screen_name => "twit_monst11"
#})
