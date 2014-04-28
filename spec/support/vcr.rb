require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/cassette_library'
  config.stub_with :webmock
  config.ignore_localhost = true
  config.default_cassette_options = {
    :record => :none
    #:record => :all
    #:record => :new_episodes
  }
end
