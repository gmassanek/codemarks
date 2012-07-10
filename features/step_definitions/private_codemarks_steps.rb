When /^I fill out the form with Twitter$/ do
  Fabricate(:topic, :title => 'twitter')
  page.fill_in('url', :with => 'http://www.twitter.com')
  page.click_button('fetch')
  wait_until { find('#codemark_title').visible? }
end

When /^I submit the form$/ do
  page.click_button('fetch')
end

Given /^I add the 'private' tag$/ do
  Fabricate(:topic, :title => 'private')
  page.fill_in('link_form_topic_autocomplete', :with => 'private')
  page.find('.ui-menu-item a').click()
end

Given /^I have a private codemark$/ do
  private = Fabricate(:topic, :title => 'private')
  @codemark = Fabricate(:codemark_record, :topics => [private], :user => @current_user)
end

Given /^another user has a private codemark$/ do
  @user = Fabricate(:user)
  @codemark = Fabricate(:codemark_record, :user => @user, :private => true)
end

Then /^that codemark should be private$/ do
  twitter = CodemarkRecord.last
  twitter.should be_private
end
