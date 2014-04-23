require 'spec_helper'

describe 'Authentication' do
  include Capybara::DSL

  describe 'creates new users' do
    it 'from twitter' do
      visit new_session_path
      expect {
        within('#main_content.sessions.new') { page.click_link 'sign in with twitter' }
      }.to change(User, :count).by(1)
    end

    it 'from github' do
      visit new_session_path
      expect {
        within('#main_content.sessions.new') { page.click_link 'sign in with github' }
      }.to change(User, :count).by(1)
    end

    it "sets the user's slug from the auth's nickname" do
      visit new_session_path
      within('#main_content.sessions.new') { page.click_link 'sign in with github' }
      user = User.last
      user.slug.should == user.authentications.first.nickname
    end
  end

  describe 'logs users in' do
    it 'from twitter', :js => true do
      # create user and logout
      visit new_session_path
      within('#main_content.sessions.new') { page.click_link 'sign in with twitter' }
      page.execute_script("$('.options').show()")
      page.click_link 'Log Out'

      visit new_session_path
      expect {
        within('#main_content.sessions.new') { page.click_link 'sign in with twitter' }
      }.to change(User, :count).by(0)
    end

    it 'from github', :js => true do
      # create user and logout
      visit new_session_path
      within('#main_content.sessions.new') { page.click_link 'sign in with github' }
      page.execute_script("$('.options').show()")
      page.click_link 'Log Out'

      visit new_session_path
      expect {
        within('#main_content.sessions.new') { page.click_link 'sign in with github' }
      }.to change(User, :count).by(0)
    end
  end
end
