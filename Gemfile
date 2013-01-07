source 'http://rubygems.org'

gem 'rails', '3.2'
gem 'jquery-rails'
gem 'friendly_id', "~> 4.0.0.beta14"
gem 'bcrypt-ruby'
gem 'fabrication'
gem 'ffaker'
gem 'nokogiri'
gem 'kaminari'
gem 'gravatar_image_tag'
gem 'omniauth-twitter'
gem 'omniauth-github', "~> 1.0.1"
#gem 'therubyracer'
#gem 'libv8', '~> 3.11.8' # You might need the native extentions for ruby racer
gem 'newrelic_rpm'
gem 'haml'
gem 'pg'
gem 'browser'
gem 'bourbon'
gem 'thin'
gem 'unicorn'
gem 'capistrano'
gem 'aws-sdk'
gem 'grabzit'
gem 'delayed_job_active_record'
gem 'daemons'
gem "postrank-uri", "~> 1.0.17"
gem 'gibbon'
gem 'whenever', "0.7", :require => false

group :development, :test do
  gem 'rspec-rails', '~> 2.8.0'
  gem 'database_cleaner'
  gem 'gherkin'
  gem 'capybara', '~> 1.1.0'
  gem 'poltergeist'
  gem 'jasmine', '~> 1.2.0'
  gem 'watchr'
  gem 'foreman'
  gem 'pry'
  gem "vcr", "~> 2.3.0"
end

group :test do
  gem 'cucumber-rails', :require => false
  gem "webmock", "~> 1.9.0"
  # used for Rack::SimpleEndpoint in test environment for
  # PhantomJS crash workaround
  gem 'rack-contrib'
end

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

group :development do
  gem 'launchy'
end
