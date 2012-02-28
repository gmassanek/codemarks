When /^I fill out the codemark form with Twitter$/ do
  page.fill_in("resource_attrs_url", :with => "http://www.twitter.com")
  page.click_button("fetch")
  wait_until { find('#resource_attrs_title').visible? }
  page.click_button("fetch")
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end
