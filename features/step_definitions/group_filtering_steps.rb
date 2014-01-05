Given /^I am in group1$/ do
  @group1 = Group.find_or_create_by_name('Group 1')
  @current_user.groups << @group1
end

Given /^user2 is in group2$/ do
  @user2 = Fabricate(:user)
  @group2 = Group.find_or_create_by_name('Group 2')
  @user2.groups << @group2
end

Given /^I have a codemark in no group$/ do
  @codemark = Fabricate(:codemark, :user => @current_user, :group => nil)
end

Given /^I have a codemark in group1$/ do
  @codemark = Fabricate(:codemark, :user => @current_user, :group => @group1)
end

When /^I filter to group1$/ do
  step 'I am on the codemarks page'
  page.evaluate_script("$('.other_sorts a[data-group=#{@group1.id}]').click()")
end

When /^I filter to No Group$/ do
  page.evaluate_script("$('.other_sorts a[data-group]:first').click()")
end

Given /^user2 has a codemark in group2$/ do
  @codemark = Fabricate(:codemark, :user => @user2, :group => @group2)
end

Given /^user2 has a codemark in no group$/ do
  @codemark = Fabricate(:codemark, :user => @user2, :group => nil)
end

Then /^I can not see group options$/ do
  page.should_not have_selector('.filter.group')
end
