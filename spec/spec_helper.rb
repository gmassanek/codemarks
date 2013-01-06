ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'

require 'webmock/rspec'
require 'capybara/poltergeist'

include Exceptions
include Codemarks

TEST_BROKEN = true
SKIP_JS = false
SKIP_SEARCH_INDEXES = true

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
RSpec::Matchers::OperatorMatcher.register(ActiveRecord::Relation, '=~', RSpec::Matchers::MatchArray)

RSpec.configure do |config|
  if TEST_BROKEN == false
    config.filter_run_excluding :broken => true
  end
  if SKIP_JS == true
    config.filter_run_excluding :js => true
  end
  if SKIP_SEARCH_INDEXES == true
    config.filter_run_excluding :search_indexes => true
  end

  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.extend VCR::RSpec::Macros
  Capybara.javascript_driver = :poltergeist
end

def simulate_signed_in
  # Change this to stub_user! and just stub user on controller?
  visit new_session_path
  page.click_link("sign in with twitter")
  @user = User.last
end

def simulate_github_signed_in
  visit root_path
  page.click_link("sign in with github")
  @user = User.last
end
