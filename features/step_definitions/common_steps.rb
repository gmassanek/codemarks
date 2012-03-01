Then /^show me the page$/ do
  save_and_open_page
end

Then /^save and open page$/ do
  save_and_open_page
end

When /^I click "([^"]*)"$/ do |arg1|
  page.click_link_or_button(arg1)
end
