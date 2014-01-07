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

Given /^I am not logged in$/ do
  step 'I am not logged in anymore'
end

Given /^I have (\d+) codemark(s)$/ do |num, _|
  @codemarks = []
  num.to_i.times do
    topics = [Fabricate(:topic), Topic.last].compact
    @codemarks << Fabricate(:codemark, :user => @current_user, :topics => topics)
  end
  @codemarks
end

Given /^I am in the "(.*?)" group$/ do |group_name|
  @group = Group.find_or_create_by_name(group_name)
  @current_user.update_attributes(:groups => Group.all)
end

Given /^I have (\d+) text codemark(s)$/ do |num, _|
  @codemarks = []
  num.to_i.times do
    topics = [Fabricate(:topic), Topic.last].compact
    textmark = Text.create!(:text => 'wooooohooo')
    @codemarks << Fabricate(:codemark, :resource => textmark, :user => @current_user, :topics => topics)
  end
  @codemarks
end

When /^I go to the second page$/ do
  visit '/codemarks?page=2'
  step 'I wait until all Ajax requests are complete'
end

When /^I select "(.*?)" from "(.*?)"$/ do |val, selector|
  page.execute_script("$('#{selector}').select2('data', {id: '#{val}', text: '#{val}'})")
end

When /^I am on the codemarks page$/ do
  visit '/codemarks'
  step 'I wait until all Ajax requests are complete'
end

When /^I click "([^"]*)"$/ do |arg1|
  page.click_link_or_button(arg1)
end

When /^I copy that codemark/ do
  page.execute_script("$('.codemark .hover-icons').show()")
  find('.add').click()
end

When /^I click the edit icon$/ do
  find('.codemark .icon').click()
end

Then /^I should not see the copy icon$/ do
  page.execute_script("$('.codemark .hover-icons').show()")
  page.should_not have_selector('.add')
end

When /^I wait until all Ajax requests are complete$/ do
  start = Time.now
  while true
    break if page.evaluate_script('$.active') == 0
    if Time.now > start + 5.seconds
      fail "AJAX never finished"
    end
    sleep 0.1
  end
end

When /^I am on the codemarks page with "(\w*\d*?)" (\w*\d*?) filter$/ do |filter_val, filter_type|
  visit codemarks_path(:group_id => filter_val)
end

Then /^I should not have the "(\w*\d*?)" (\w*\d*?) filter$/ do |filter_val, filter_type|
  current_url.should_not match "#{filter_type}=#{filter_val}"
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

Then /^I can see (my|that) codemark$/ do |_|
  step "I am on the codemarks page"
  codemark = @codemark || @codemarks.first
  page.should have_content(codemark.title)
end

Then /^I can not see (my|that) codemark$/ do |_|
  step "I am on the codemarks page"
  codemark = @codemark || @codemarks.first
  page.should_not have_content(codemark.title)
end

Then /^I should see (my|that) codemark$/ do |_|
  codemark = @codemark || @codemarks.first
  page.should have_content(codemark.title)
end

Then /^I should not see that codemark$/ do
  step 'I wait until all Ajax requests are complete'
  page.should_not have_content(@codemark.title)
end
