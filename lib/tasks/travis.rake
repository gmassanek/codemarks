desc 'Tasks for travic-ci'
task :travis do
  ["rspec spec", "cucumber --tags ~@javascript", "rake jasmine:ci"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
