desc 'Tasks for travic-ci'
task :travis do
  ["rspec spec --tag ~travis_skip", "rake cucumber", "rake jasmine:ci"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
