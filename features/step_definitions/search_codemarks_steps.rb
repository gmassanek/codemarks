Given /^"([^"]*)" is a topic$/ do |topic_title|
  @topic = Fabricate(:topic, :title => topic_title)
end

When /^I search for that topic$/ do
  save_and_open_page
  page.fill_in('#_topic_autocomplete', :with => @topic.title)
  page.find_field('#_topic_autocomplete').native.send_key(:enter)
end

Then /^I should be on that topic's page$/ do
  page.should have_content(@topic.description)
end

Given /^pending$/ do
  pending # express the regexp above with the code you wish you had
end
