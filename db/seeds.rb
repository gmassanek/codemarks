require 'csv'
require 'codemarker'

CSV_DIR = "db/seed_data/"

#Topics
file_name = "rubeco_topics_12-2.csv"
path_to_file = CSV_DIR + file_name

CSV.foreach(path_to_file, {:headers => true}) do |row|
  title = row[1]
  unless Topic.find_by_title title
    description = row[2]
    Topic.create(title: title, description: description)
  end
end

file_name = "rubeco_links_short_2-27.csv"
#file_name = "rubeco_links_12-2.csv"
path_to_file = CSV_DIR + file_name

CSV.foreach(path_to_file, {:headers => true}) do |row|
  url = row[1]
  user = User.first
  unless LinkRecord.find_by_url(url)
    puts "Saving #{url}"
    begin
      cm = Codemark.prepare(:link, :url => url)
      Codemark.create({:type => :link}, cm.resource.resource_attrs, cm.topics, Fabricate(:user))
    rescue Exception => ex
      puts "Problem saving #{url}"
      puts ex.inspect
    end
  end
end


puts "#{Topic.count} topics created"
puts "#{LinkRecord.count} link record created"
puts "#{CodemarkRecord.count} codemark records created"
puts "#{CodemarkTopic.count} codemark topics created"
puts "#{User.count} users created"

