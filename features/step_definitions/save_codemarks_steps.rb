When /^I fill out the codemark form with Twitter$/ do
  Fabricate(:topic, :title => "twitter")
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

Given /^there is (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record)
end

When /^I fill out the codemark form with the existing one$/ do
  page.fill_in("resource_attrs_url", :with => @codemark.url)
  page.click_button("fetch")
  wait_until { find('#resource_attrs_title').visible? }
  page.click_button("fetch")
end

Then /^I should have (\d+) codemark$/ do |num_codemarks|
  @current_user.codemark_records.count.should == num_codemarks.to_i
end

Then /^there should be (\d+) codemarks$/ do |codemark_count|
  CodemarkRecord.count.should == codemark_count.to_i
end

Then /^there should be (\d+) links/ do |link_count|
  LinkRecord.count.should == link_count.to_i
end

Then /^I should see the data for that codemark in the codemark form$/ do
  wait_until { find('#resource_attrs_title').visible? }
  within("#codemark_form") do
    page.should have_selector('#resource_attrs_title', :content => @codemark.title)
  end
end
