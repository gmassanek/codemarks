Given /^I am logged in$/ do
  visit new_session_path
  page.click_link('sign in with twitter')
  visit '/'
  @current_user = User.last
end

When /^I sign up with twitter$/ do
  visit new_session_path
  page.click_link("sign in with twitter")
  @current_user = User.last
end

Given /^Tom Brady is a user$/ do
  @tom_brady = Fabricate(:user, :nickname => 'tom-brady')
end

Given /^I am not logged in anymore$/ do
  visit '/'
  page.execute_script("$('.options').show()")
  click_link 'Log Out'
end

Given /^I have (\d+) codemarks$/ do |num|
  @codemarks = []
  num.to_i.times do
    @codemarks << Fabricate(:codemark_record, :user => @current_user)
  end
  @codemarks
end

When /^I am on the codemarks page$/ do
  visit '/codemarks'
  step 'I wait until all Ajax requests are complete'
end

When /^I click "([^"]*)"$/ do |arg1|
  page.click_link_or_button(arg1)
end

When /^I copy that codemark/ do
  page.driver.browser.execute_script("$('.codemark .hover-icons').show()")
  find('.add').click()
end

When /^I click the edit icon$/ do
  find('.codemark .icon').click()
end

Then /^I should not see the copy icon$/ do
  page.driver.browser.execute_script("$('.codemark .hover-icons').show()")
  page.should_not have_selector('.add')
end

When /^I wait until all Ajax requests are complete$/ do
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^save and open page$/ do
  save_and_open_page
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should not see "([^"]*)"$/ do |content|
  page.should_not have_content(content)
end

Then /^I should see (my|that) codemark$/ do |_|
  page.should have_content(@codemark.title)
end

Then /^I should not see that codemark$/ do
  page.should_not have_content(@codemark.title)
end
