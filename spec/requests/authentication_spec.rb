require 'spec_helper'

describe 'Authentication' do
  include Capybara::DSL

  describe 'creates new users' do
    it 'from twitter', :type => :request do
      visit new_session_path
      expect {
        page.click_link 'sign in with twitter'
      }.to change(User, :count).by(1)
    end

    it 'from github' do
      visit new_session_path
      expect {
        page.click_link 'sign in with github'
      }.to change(User, :count).by(1)
    end

    it "sets the user's slug from the auth's nickname" do
      visit new_session_path
      page.click_link 'sign in with github'
      user = User.last
      user.slug.should == user.authentications.first.nickname
    end
  end

  describe 'logs users in' do
    it 'from twitter' do
      # create user and logout
      visit new_session_path
      page.click_link 'sign in with twitter'
      page.click_link 'log out'

      visit new_session_path
      expect {
        page.click_link 'sign in with twitter'
      }.to change(User, :count).by(0)
    end

    it 'from github' do
      # create user and logout
      visit new_session_path
      page.click_link 'sign in with github'
      page.click_link 'log out'

      visit new_session_path
      expect {
        page.click_link 'sign in with github'
      }.to change(User, :count).by(0)
    end
  end
end
