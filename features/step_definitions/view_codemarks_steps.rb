Given /^I am a logged in user$/ do
  visit '/'
  page.click_link('sign in with twitter')
  @user = User.last
  p @user
end

Given /^I have (\d+) codemarks$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I go to my dashboard$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see (\d+) codemarks$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
