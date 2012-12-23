namespace :jasmine  do
  desc 'Use jasmine without webmocks blocking connections'
  task :ci_allowed do
    require 'webmock'
    WebMock.allow_net_connect!
    Rake::Task["jasmine:ci"].invoke
  end
end
