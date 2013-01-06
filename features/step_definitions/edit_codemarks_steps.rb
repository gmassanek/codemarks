When /^I click the delete image/ do
  page.execute_script("$('.codemark .hover-icons').show()")
  page.find('.delete').click()
end

Then /^I do not see my codemark$/ do
  page.should_not have_selector('.codemark')
end
