Given /^I have (\d+) codemarks$/ do |num|
  @codemarks = []
  num.to_i.times do
    @codemarks << Fabricate(:codemark_record, :user => @user)
  end
  @codemarks
end

Given /^I am a logged in user$/ do
  visit '/'
  page.click_link('sign in with twitter')
  @user = User.last
end

When /^I click "([^"]*)"$/ do |arg1|
  page.click_link_or_button(arg1)
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^save and open page$/ do
  save_and_open_page
end
