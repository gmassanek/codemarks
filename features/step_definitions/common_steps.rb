Given /^I have (\d+) codemarks$/ do |num|
  @codemarks = []
  num.to_i.times do
    @codemarks << Fabricate(:codemark_record, :user => @current_user)
  end
  @codemarks
end

Given /^I am a logged in user$/ do
  visit '/'
  page.click_link('sign in with twitter')
  @current_user = User.last
end

When /^I click "([^"]*)"$/ do |arg1|
  page.click_link_or_button(arg1)
end

When /^I copy that codemark/ do
  p find('.copy_codemark')
  find('.copy_codemark').click
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^save and open page$/ do
  save_and_open_page
end

Then /^I should not see "([^"]*)"$/ do |content|
  page.should_not have_content(content)
end
