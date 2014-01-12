Given /^there is a text codemark in group1$/ do
  @codemark = Fabricate(:codemark, :resource => Text.create!(:text => 'foo text'), :group => Group.find_or_create_by_name("Group 1"))
end

Given /^I have a text codemark in group1$/ do
  @codemark = Fabricate(:codemark, :resource => Text.create!(:text => 'foo text'), :user => @current_user, :group => Group.find_or_create_by_name('Group 1'))
end

Given /^there is a text codemark$/ do
  @codemark = Fabricate(:codemark, :resource => Text.create!(:text => 'foo text'))
end

Then /^I can edit that text codemark$/ do
  visit codemark_path(@codemark)
  page.should have_selector('.edit-codemark')
end

Then /^I cannot edit that text codemark$/ do
  visit codemark_path(@codemark)
  page.should_not have_selector('.edit-codemark')
end
