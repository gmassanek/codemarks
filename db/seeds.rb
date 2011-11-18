# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Link.destroy_all
LinkTopic.destroy_all
Topic.destroy_all
["Rspec", "Github", "Cucumber", "Capybara", "Git", "JQuery", "Ruby", "Ruby on Rails"].each do |title|
  Fabricate(:topic_with_sponsored_links, :title => title)
end
puts "#{Topic.count} topics created"
