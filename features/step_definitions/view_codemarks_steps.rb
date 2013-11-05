Given /^someone else has codemarks$/ do
  2.times { Fabricate(:codemark) }
end

Given /^one of my codemarks has been save (\d+) other times$/ do |num|
  @codemark = @codemarks.first
  num.to_i.times do
    Fabricate(:codemark, :resource => @codemark.resource)
  end
end

Given /^I have a codemarks called "([^"]*)"$/ do |title|
  link = Fabricate(:link, :title => title)
  @codemark = Fabricate(:codemark, :title => title, :resource => link, :user => @current_user)
end

Given /^there are (\d+) codemarks for "([^"]*)"$/ do |num_codemarks, topic_title|
  @topic = Fabricate(:topic, :title => topic_title)
  num_codemarks.to_i.times do
    Fabricate(:codemark, :topic_ids => [@topic.id])
  end
end

Given /^([^"]*) is a user with a codemark$/ do |nickname|
  @user = Fabricate(:user, :nickname => nickname)
  topic = Fabricate(:topic)
  @topic = Fabricate(:topic)
  @codemark = Fabricate(:codemark, :user => @user, :topics => [@topic, topic])
end

Given /^there are (\d+) random codemarks$/ do |num|
  @codemarks = []
  while @codemarks.length < num.to_i do
    begin
      @codemarks << Fabricate(:codemark)
    rescue ActiveRecord::RecordInvalid
      next
    end
  end
end

Given /^([^"]*) is a user with a codemark for that topic$/ do |nickname|
  @user = Fabricate(:user, :nickname => nickname)
  @another_codemark = Fabricate(:codemark, :user => @user, :topic_ids => [@topic.id])
end

Given /^the last codemark doesn't have a link$/ do
  @codemarks.last.update_attribute(:resource, nil)
end

When /^I go to the "([^"]*)" topic page$/ do |topic_title|
  visit topic_path(@topic)
end

When /^I go to my codemarks page$/ do
  visit codemarks_path(:user => @current_user)
end

When /^I go to his codemarks page$/ do
  visit codemarks_path(:user => @user)
end

When /^I go to that topic page$/ do
  visit topic_path(@topic)
end

When /^I click on that codemark$/ do
  click_on @codemarks.first.title
end

When /^I click on my name$/ do
  within '.codemark.mine .author' do
    click_on @current_user.nickname
  end
end

Then /^I should be on the show page$/ do
  current_path.should == codemark_path(@codemarks.first)
end

Then /^I should see his codemark$/ do
  page.should have_content(@codemark.title)
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

Then /^I should see a twitter share link$/ do
  page.execute_script("$('.codemark .hover-icons').show()")
  page.should have_selector('.share')
end

Then /^the "(.*?)" tab should be active$/ do |tab_identifier|
  page.should have_selector('.tabs li.active', :count => 1)
  within '.tabs li.active' do
    page.should have_content(tab_identifier)
  end
end
