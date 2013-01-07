require 'spec_helper'

describe UsersController do
  describe 'index' do
    it 'fetches all users' do
      Fabricate(:user)
      Fabricate(:user)
      get users_path
      assigns(:users).should have(2).items
    end
  end
end
