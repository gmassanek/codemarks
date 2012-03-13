require 'spec_helper'

describe "User Profile Page" do
  context "show" do
    before do
      simulate_signed_in
      @user = Fabricate(:user)
      visit short_user_path(@user.to_param)
    end

    it "contains the user's nickname" do
      current_path.should include(@user.nickname)
    end

    it "does what the dashboard does"
    it "doesn't show me their private links"
    it "shows their account details on the top of the page"
  end

  context "account" do
    before do
      simulate_signed_in
      visit account_path(@user)
    end

    it "lands you on the user account page" do
      current_path.should == account_path(@user)
    end

    it "has my name" do
      page.should have_content(@user.name)
    end

    it "has my email" do
      page.should have_content(@user.email)
    end

    it "has my nickname" do
      page.should have_content(@user.nickname)
    end

    it "has my location" do
      page.should have_content(@user.location)
    end

    it "has my description" do
      page.should have_content(@user.description)
    end
  end

  it "finds a user by authenticaion and username" do
    user = Fabricate(:user)
    authentication = user.authentications.first
    provider = authentication.provider
    nickname = authentication.nickname

    User.find_by_authentication(provider, nickname).should == user
  end

  context "lets you update your info" do
    before do
      simulate_signed_in
      visit account_path(@user)
      page.click_link "Edit"
    end

    it "asks you for your email address" do
      page.should have_field("user_email")
    end

    it "saves your email address" do
      page.fill_in "user_email", :with => "test@example.com"
      page.click_button "Save"
      @user.reload.email.should == "test@example.com"
      page.should have_content "test@example.com"
    end

    it "displays the authentication's value if it's present" do
      page.should have_field("user_location", with: @user.get(:location))
      page.should have_field("user_description", with: @user.get(:description))
      page.should have_field("user_email", with: @user.get(:email))
      page.should have_field("user_nickname", with: @user.get(:nickname))
    end
  end
end
