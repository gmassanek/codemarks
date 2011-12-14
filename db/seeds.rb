require 'csv'
require 'smart_link'
require 'link_saver'
include OOPs

CSV_DIR = "db/seed_data/"

#users
Fabricate(:user)

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
  user = User.first
  unless Link.find_by_url(url)
    puts "Saving #{url}"
    begin
      link = Link.new
      link.url = url
      smart_link = SmartLink.new(link.url)
      if smart_link.response
        link.title = smart_link.title
        link.host = smart_link.host
        topics = smart_link.topics
        LinkSaver.save_link!(link, user, topics) 
      end
    rescue Exception => ex
      puts "Problem saving #{url}"
      puts ex.inspect
    end
  end
end


puts "#{Topic.count} topics created"
puts "#{Link.count} links created"
puts "#{LinkTopic.count} link topics created"
puts "#{LinkSave.count} link saves created"
puts "#{User.count} users created"

