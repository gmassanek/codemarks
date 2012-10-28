When /^I fill out the add codemark form with Twitter$/ do
  Fabricate(:topic, :title => 'twitter')
  page.find('.add_link a').click()
  page.fill_in('url', :with => 'http://www.twitter.com')
  page.click_button('Add')
  step 'I wait until all Ajax requests are complete'
  page.click_button('Submit')
end

When /^I fill out the codemark form with the existing one$/ do
  page.find('.add_link a').click()
  page.fill_in('url', :with => @codemark.url)
  page.click_button('Add')
  step 'I wait until all Ajax requests are complete'
  page.click_button('Submit')
end

When /^I submit the codemark form$/ do
  page.click_button('Submit')
end

Given /^I have (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record, :user => @current_user)
end

Given /^there is (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record)
end

Given /^tom_brady has codemarked Twitter$/ do
  @tom_brady = Fabricate(:user, :nickname => 'tom_brady')
  twitter = Fabricate(:link_record, :author => @tom_brady, :url => 'http://www.twitter.com')
  @codemark = @twitter = Fabricate(:codemark_record, :user => @tom_brady, :resource => twitter)
end

Then /^I should see a codemark form$/ do
  page.should have_selector('.tile form.codemark_form')
end

Then /^tom_brady should still be Twitter's author$/ do
  @twitter.reload.resource_author.should == @tom_brady
end

Then /^I should be Twitter's author$/ do
  twitter = LinkRecord.find_by_url('http://www.twitter.com')
  twitter.author.should == @current_user
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
