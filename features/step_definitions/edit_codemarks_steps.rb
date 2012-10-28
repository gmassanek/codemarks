When /^I accept the prompt$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I click the delete image/ do
  page.driver.browser.execute_script("$('.codemark .hover-icons').show()")
  page.find('.delete').click()
end

Then /^I do not see my codemark$/ do
  page.should_not have_selector('.codemark')
end
