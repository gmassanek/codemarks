Then /^I should see the codemark form$/ do
  page.should have_selector("#codemark_form")
end

Then /^I should see the data for my codemark in the codemark form$/ do
  codemark = @codemarks.first
  wait_until { find('#resource_attrs_title').visible? }
  within("#codemark_form") do
    page.should have_selector('#resource_attrs_title', :content => codemark.title)
    page.should have_content(codemark.topics.first.title)
  end
end

When /^I accept the prompt$/ do
  page.driver.browser.switch_to.alert.accept
end

Then /^I not see my codemark$/ do
  page.should_not have_selector('.codemark')
end
