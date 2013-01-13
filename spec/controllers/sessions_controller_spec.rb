require 'spec_helper'

describe SessionsController do
  describe 'new' do
    it 'redirects to codemarks controller if logged in already' do
      user = Fabricate(:user)
      controller.stub(:current_user => user)
      get :new
      response.should be_redirect
    end
  end

  describe 'destroy' do
    it 'logs users out' do
      user = Fabricate(:user)
      cookies.permanent.signed[:remember_token] = user.id
      get :new

      delete :destroy
      controller.should_not be_logged_in
    end
  end
end
