Given /^that link has a link_topic for "([^"]*)"$/ do |arg1|
  link = Link.last
  topic = Topic.find_by_title(arg1)
  link.link_topics.build(:topic => topic)
  link.save
end
