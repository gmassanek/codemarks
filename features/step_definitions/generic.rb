Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should see a link to "([^"]*)"$/ do |arg1|
  page.should have_link(arg1)
end

Then /^show me the page/ do
  save_and_open_page
end
