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
  pending # express the regexp above with the code you wish you had
end

Then /^I should see my top topics$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see an edit profile link$/ do
  pending # express the regexp above with the code you wish you had
end
