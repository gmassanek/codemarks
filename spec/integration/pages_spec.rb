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
    #it "signs me up when I click on the twitter link" do
    #  page.click_link "sign in with twitter"
    #  within "#finish_profile" do
    #    page.should have_link "profile"
    #    page.should have_content "github"
    #  end
    #end

    #it "signs me up when I click on the github link" do
    #  page.click_link "sign in with github"
    #  within "#finish_profile" do
    #    page.should have_link "profile"
    #    page.should have_content "twitter"
    #  end
    #end
  end

  it "redirects to codemarks page when a user is logged in" do
    simulate_signed_in
    visit root_path
    current_path.should == codemarks_path
  end

end

