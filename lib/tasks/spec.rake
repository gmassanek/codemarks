desc 'Test scripts that do not rely on rake (to avoid db:test:prepare)'
task :specs do
  ["rspec spec", "cucumber", "rake jasmine:ci"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
