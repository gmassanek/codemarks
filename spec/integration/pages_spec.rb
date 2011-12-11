require 'spec_helper'

describe "Home page" do
  before do 
    visit root_path
  end

  it "has a twitter login link" do
    page.should have_link("sign in with twitter")
  end

  it "has a github login link" do
    page.should have_link("sign in with github")
  end

  context "as a new user" do
    it "signs me up when I click on the twitter link" do
      page.click_link "sign in with twitter"
      page.should have_content "Signed in successfully"
    end

    it "signs me up when I click on the github link" do
      page.click_link "sign in with github"
      page.should have_content "Signed in successfully"
    end
  end

  it "redirects to user show page when a user is logged in" do
    simulate_signed_in
    visit root_path
    current_path.should == user_path(@user)
  end
end
