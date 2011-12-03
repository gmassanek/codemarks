require 'csv'
require 'smart_links'
require 'link_saver'

CSV_DIR = "db/seed_data/"

#users
["system@example.com", "test@example.com", "test2@example.com", "test3@example.com"].each do |email|
  Fabricate(:user, :email => email, :password => "password") unless User.find_by_email(email)
end

#Topics
file_name = "rubeco_topics_12-2.csv"
path_to_file = CSV_DIR + file_name

CSV.foreach(path_to_file, {:headers => true}) do |row|
  title = row[1]
  unless Link.find_by_title title
    description = row[2]
    Topic.create(title: title, description: description)
  end
end

#Links
file_name = "rubeco_links_12-2.csv"
path_to_file = CSV_DIR + file_name

CSV.foreach(path_to_file, {:headers => true}) do |row|
  url = row[1]
  unless Link.find_by_url(url)
    puts "Saving #{url}"
    begin
      link = Link.new(url: url)
      curler = SmartLinks::MyCurl.new(url)
      sysuser = User.find_by_email "system.example.com"

      ResourceManager::LinkSaver.create_link({url: url}, curler.topics.collect(&:id), nil, sysuser)
    rescue
      "Could not save #{url}"
    end
  end
end


puts "#{Topic.count} topics created"
puts "#{Link.count} links created"
puts "#{LinkTopic.count} link topics created"
puts "#{LinkSave.count} link saves created"
puts "#{User.count} users created"

