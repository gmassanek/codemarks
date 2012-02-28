Given /^I am a logged in user$/ do
  visit '/'
  page.click_link('sign in with twitter')
  @user = User.last
end

Given /^I have (\d+) codemarks$/ do |num|
  num.to_i.times do 
    Fabricate(:codemark_record, :user => @user)
  end
end

When /^I go to my dashboard$/ do
  visit '/'
end

Then /^I should see (\d+) codemarks$/ do |num|
  page.should have_selector('.codemark', :count => num.to_i)
end

Given /^I have a codemarks called "([^"]*)"$/ do |title|
  link_record = Fabricate(:link_record, :title => title)
  Fabricate(:codemark_record, :link_record => link_record, :user => @user)
end

Then /^I should see a link, "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end
