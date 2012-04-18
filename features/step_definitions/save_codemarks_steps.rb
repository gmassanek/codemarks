When /^I fill out the codemark form with Twitter$/ do
  Fabricate(:topic, :title => 'twitter')
  page.fill_in('url', :with => 'http://www.twitter.com')
  page.click_button('fetch')
  wait_until { find('#resource_attrs_title').visible? }
  page.fill_in('codemark_attrs_note', :with => 'I should use this for codemarks')
  page.click_button('fetch')
end

Given /^I have (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record, :user => @current_user)
end

Given /^there is (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark_record)
end

When /^I fill out the codemark form with the existing one$/ do
  page.fill_in("url", :with => @codemark.url)
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
    # TODO Not sure why @codemark is out of scope here
    #page.should have_selector('#resource_attrs_title', :content => @codemark.title)
    #page.should have_content(@codemark.topics.first.title)
  end
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^that codemark should have a note$/ do
  FindCodemarks.new(:user => @current_user).codemarks.first.note.should_not be_nil
end
