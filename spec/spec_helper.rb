ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

include Exceptions
include OOPs

TEST_BROKEN = false

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:twitter, {
  :uid => '12345',
  :nickname => 'zapnap'
})

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
