When /^I fill out the add codemark form with Google$/ do
  Fabricate(:topic, :title => 'google')
  step 'I get to the new link form'
  page.fill_in('url', :with => 'http://www.google.com')
  page.click_button('Add')
  step 'I wait until all Ajax requests are complete'
end

When /^I get to the new link form$/ do
  page.find('.add_codemark a').trigger('click')
  page.find('.add_link a').click()
end

When /^I get to the new text form$/ do
  page.find('.add_codemark a').trigger('click')
  page.find('.add_note a').click()
end

When /^I fill out and submit the add codemark form with Google$/ do
  step 'I fill out the add codemark form with Google'
  step 'I submit the codemark form'
end

When /^I open the codemarklet for Google$/ do
  Fabricate(:topic, :title => 'google')
  visit new_codemarklet_path(:url => 'http://www.google.com')
end

When /^I fill out the codemark form with the existing one$/ do
  step 'I get to the new link form'
  page.fill_in('url', :with => @codemark.url)
  page.click_button('Add')
  step 'I wait until all Ajax requests are complete'
  page.click_button('Submit')
  step 'I wait until all Ajax requests are complete'
end

When /^I submit the codemark form$/ do
  page.click_button('Submit')
  step 'I wait until all Ajax requests are complete'
end

Given /^I have (a|1) codemark$/ do |arg1|
  @codemark = Fabricate(:codemark, :user => @current_user)
end

Given /^there is (a|1) codemark$/ do |arg1|
  link = Fabricate(:link, :url => 'http://www.google.com/')
  @codemark = Fabricate(:codemark, :resource => link)
end

Given /^tom_brady has codemarked Google$/ do
  google = Fabricate(:link, :author => @tom_brady, :url => 'http://www.google.com')
  topic = Fabricate(:topic, :title => 'Google')
  @codemark = @google = Fabricate(:codemark, :user => @tom_brady, :resource => google, :topics => [topic])
end

Given /^I fill out and submit the add note codemark form with "(.*?)"$/ do |note_text|
  step 'I get to the new text form'
  page.fill_in('text', :with => note_text)
  page.click_button('Submit')
  step 'I wait until all Ajax requests are complete'
end

Given /^I fill out and submit the add codemark form with Google in that group$/ do
  step 'I fill out the add codemark form with Google'
  page.select(@group.name, :from => 'group_id')
  step 'I submit the codemark form'
end

Then /^I should be that codemark's author$/ do
  Codemark.last.resource.author.should == @current_user
end

Then /^I should see a codemark form$/ do
  page.should have_selector('form.codemark_form')
end

Then /^tom_brady should still be Google's author$/ do
  @google.reload.resource_author.should == @tom_brady
end

Then /^I should be Google's author$/ do
  google = Link.has_url('http://www.google.com/').first
  google.author.should == @current_user
end

Then /^I should have (\d+) codemark$/ do |num_codemarks|
  @current_user.codemarks.count.should == num_codemarks.to_i
end

Then /^there should be (\d+) codemarks$/ do |codemark_count|
  Codemark.count.should == codemark_count.to_i
end

Then /^there should be (\d+) links/ do |link_count|
  Link.count.should == link_count.to_i
end

Then /^that codemark should have a note$/ do
  FindCodemarks.new(:user => @current_user).codemarks.first.note.should_not be_nil
end

Then /^that codemark should be in that group$/ do
  Codemark.last.group.should == @group
end
