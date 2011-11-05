Given /^the following topics_with_sponsored$/ do |table|
  table.hashes.each do |attributes|
    Fabricate(:topic_with_sponsored_links, attributes)
  end
end
Given /^the following topics_without_sponsored$/ do |table|
  table.hashes.each do |attributes|
    Fabricate(:topic, attributes)
  end
end

When /^I go to the topics page$/ do
  visit topics_path
end

When /^I go to the ([^"]*) topic page$/ do |arg1|
  topic = Topic.find_by_title arg1
  visit topic_path topic
end

When /^I go to the ([^"]*) topic edit page$/ do |arg1|
  topic = Topic.find_by_title arg1
  visit edit_topic_path topic
end

When /^I add a new topic with title:"([^"]*)"$/ do |arg1|
  visit new_topic_path
  page.fill_in "Title", :with => arg1
  page.fill_in "Description", :with => Faker::Lorem.words(60).join(' ')
  page.click_button "Create Topic"
end

