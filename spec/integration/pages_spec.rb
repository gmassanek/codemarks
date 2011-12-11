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

  context "as a returning user" do
    it "logs me in when I click on the twitter link" do
      page.click_link "sign in with twitter"
      page.should have_content "Signed in successfully"
    end

    it "signs me up when I click on the github link" do
      page.click_link "sign in with github"
      page.should have_content "Signed in successfully"
    end
  end
end
