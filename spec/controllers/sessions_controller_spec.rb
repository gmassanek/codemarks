require 'spec_helper'

describe SessionsController do
  describe "POST create" do
    it "makes a call to Authenticator" do
      OOPs::Authenticator.should_receive(:find_or_create_from_auth_hash)
      post :create
    end
  end
end
