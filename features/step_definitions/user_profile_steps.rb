When /^I click on my profile link$/ do
  page.execute_script("$('header.options').show()")
  click_link 'Profile'
end

Then /^I should be on my user show page$/ do
  current_path.should == user_path(@current_user)
end

Then /^I should see my profile data$/ do
  page.should have_content @current_user.name
  page.should have_content @current_user.nickname
  page.should have_content @current_user.email
  page.should have_content @current_user.description
  page.should have_content @current_user.location
end

Then /^I should see some of my codemarks$/ do
  step 'I wait until all Ajax requests are complete'
  page.should have_selector('.codemark', :count => 3)
end

Then /^I should see my top topics$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see an edit profile link$/ do
  within '.side' do
    page.should have_link 'Edit'
  end
end

When /^I go to tom\-brady's profile$/ do
  visit user_path(@tom_brady)
end

Then /^I should see tom\-brady's profile data$/ do
  page.should have_content @tom_brady.name
  page.should have_content @tom_brady.nickname
  page.should have_content @tom_brady.email
  page.should have_content @tom_brady.description
  page.should have_content @tom_brady.location
end

Then /^I should see Google$/ do
  step 'I wait until all Ajax requests are complete'
  page.should have_selector('.codemark', :count => 1)
end

Then /^I should see tom\-brady's top topics$/ do
  pending
end

Then /^I should not see an edit profile link$/ do
  within '.side' do
    page.should_not have_link 'Edit'
  end
end
