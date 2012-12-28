When /^I fill out the add codemark form with Google$/ do
  Fabricate(:topic, :title => 'google')
  page.find('.add_link a').click()
  page.fill_in('url', :with => 'http://www.google.com')
  page.click_button('Add')
  step 'I wait until all Ajax requests are complete'
end

When /^I fill out and submit the add codemark form with Google$/ do
  step 'I fill out the add codemark form with Google'
  step 'I submit the codemark form'
end

When /^I fill out the codemark form with the existing one$/ do
  page.find('.add_link a').click()
  page.fill_in('url', :with => @codemark.url)
  page.click_button('Add')
  step 'I wait until all Ajax requests are complete'
  page.click_button('Submit')
  step 'I wait until all Ajax requests are complete'
end

When /^I submit the codemark form$/ do
  page.click_button('Submit')
end

Given /^I have (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record, :user => @current_user)
end

Given /^there is (a|1) codemark$/ do |arg1|
  link = Fabricate(:link_record, :url => 'http://www.google.com/')
  @codemark = Fabricate(:codemark_record, :resource => link)
end

Given /^tom_brady has codemarked Google$/ do
  @tom_brady = Fabricate(:user, :nickname => 'tom_brady')
  google = Fabricate(:link_record, :author => @tom_brady, :url => 'http://www.google.com')
  @codemark = @google = Fabricate(:codemark_record, :user => @tom_brady, :resource => google)
end

Then /^I should see a codemark form$/ do
  page.should have_selector('.tile form.codemark_form')
end

Then /^tom_brady should still be Google's author$/ do
  @google.reload.resource_author.should == @tom_brady
end

Then /^I should be Google's author$/ do
  google = LinkRecord.find_by_url('http://www.google.com/')
  google.author.should == @current_user
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

Then /^that codemark should have a note$/ do
  FindCodemarks.new(:user => @current_user).codemarks.first.note.should_not be_nil
end
