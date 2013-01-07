When /^I click on my profile link$/ do
  within('header') do
    page.click_link @current_user.nickname
  end
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
  topics = @current_user.codemark_records.map(&:topics).flatten.group_by(&:id)
  topics.each do |_, list|
    topic = list.first
    page.should have_content "#{topic.title} (#{list.count})"
  end
end

Then /^I should see an edit profile link$/ do
  within '.side' do
    page.should have_link 'Edit'
  end
end

When /^I go to tom\-brady's profile$/ do
  visit codemarks_path
  click_link 'tom-brady'
  step 'I wait until all Ajax requests are complete'
  within('.controlPanel') do
    click_link 'tom-brady'
  end
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
  page.should have_content "Google (1)"
end

Then /^I should not see an edit profile link$/ do
  within '.side' do
    page.should_not have_link 'Edit'
  end
end
