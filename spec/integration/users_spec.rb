require 'spec_helper'

describe "User Profile Page" do
  context "Twitter first" do
    before do
      simulate_signed_in
    end

    it "lands you on the user profile page" do
      current_path.should == profile_path
    end

    it "asks you for your email address" do
      page.should have_field("user_email")
    end

    it "saves your email address" do
      page.fill_in "user_email", :with => "test@example.com"
      page.click_button "Save"
      User.find(@user.id).email.should == "test@example.com"
      page.should have_content "test@example.com"
    end

    it "asks you to link your github" do
      page.should have_link("github_signin")
      page.should_not have_link("twitter_signin")
    end

    it "asks you to link your github" do
      page.click_link "github_signin"
      page.should_not have_link("github_signin")
      page.should_not have_link("twitter_signin")
      @user.authentications.count.should == 2
      current_path.should == profile_path
    end
  end

  it "asks you to link your github" do
    simulate_github_signed_in
    page.should_not have_link("github_signin")
    page.should have_link("twitter_signin")
  end

  it "prompts you for your email and missing authentication when you log in" do
    simulate_github_signed_in
    page.should have_link("profile")
  end
end
