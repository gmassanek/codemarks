When /^I fill out the codemark form with Twitter$/ do
  page.fill_in("resource_attrs_url", :with => "http://www.twitter.com")
  page.click_button("fetch")
  wait_until { find('#resource_attrs_title').visible? }
  page.click_button("fetch")
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Given /^I have (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record, :user => @user)
end

When /^I fill out the codemark form with mine$/ do
  page.fill_in("resource_attrs_url", :with => @codemark.url)
  page.click_button("fetch")
  wait_until { find('#resource_attrs_title').visible? }
  page.click_button("fetch")
end

Then /^I should have (\d+) codemark$/ do |num_codemarks|
  @user.codemark_records.count.should == num_codemarks.to_i
end
