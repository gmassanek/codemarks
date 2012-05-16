Given /^"([^"]*)" is a topic$/ do |topic_title|
  @topic = Fabricate(:topic, :title => topic_title)
end

When /^I search for that topic$/ do
  page.fill_in('_topic_autocomplete', :with => @topic.title)
  page.find('.ui-menu-item a').click()
end

Then /^I should be on that topic's page$/ do
  current_path.should == topic_path(@topic)
end
