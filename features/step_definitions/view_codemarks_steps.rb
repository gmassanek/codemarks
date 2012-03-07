Given /^I have (\d+) codemarks$/ do |num|
  @codemarks = []
  num.to_i.times do 
    @codemarks << Fabricate(:codemark_record, :user => @user)
  end
  @codemarks
end

Given /^there are (\d+) random codemarks$/ do |num|
  num.to_i.times do
    Fabricate(:codemark_record)
  end
end

Given /^someone else has codemarks$/ do
  2.times { Fabricate(:codemark_record) }
end

Given /^one of my codemarks has been save (\d+) other times$/ do |num|
  @codemark = @codemarks.first
  num.to_i.times do
    Fabricate(:codemark_record, :link_record => @codemark.link_record)
  end
end

Given /^I have a codemarks called "([^"]*)"$/ do |title|
  link_record = Fabricate(:link_record, :title => title)
  Fabricate(:codemark_record, :link_record => link_record, :user => @user)
end

Given /^there are (\d+) codemarks for "([^"]*)"$/ do |num_codemarks, topic_title|
  @topic = Fabricate(:topic, :title => topic_title)
  num_codemarks.to_i.times do
    Fabricate(:codemark_record, :topic_ids => [@topic.id])
  end
end

When /^I go to the "([^"]*)" topic page$/ do |topic_title|
  visit topic_path(@topic)
end

When /^I go to my dashboard$/ do
  visit '/'
end

When /^I go to the public page$/ do
  visit '/public'
end

Then /^I should see (\d+) codemarks$/ do |num|
  page.should have_selector('.codemark', :count => num.to_i)
end

Then /^I should see a link, "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I should see that codemark first$/ do
  within('.codemark:first-child') do
    page.should have_content(@codemark.title)
  end
end
