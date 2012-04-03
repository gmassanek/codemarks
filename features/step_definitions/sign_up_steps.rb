Given /^I am not a user$/ do
end

When /^I sign up with twitter$/ do
  visit root_path
  page.click_link("sign in with twitter")
  @user = User.last
end

Then /^my slug should be my twitter handle$/ do
  @user.slug.should == @user.authentications.first.nickname
end
