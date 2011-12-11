require 'spec_helper'

describe Authenticator do
  let (:auth_hash) { {"uid" => 9} }
  let (:authentication) { Fabricate(:authentication, uid: auth_hash["uid"]) }

  context "#find_or_create_user_from_auth_hash" do
    it "errors out if there is no auth hash" do
      lambda {
        Authenticator.find_or_create_user_from_auth_hash("twitter", nil)
      }.should raise_error(AuthHashRequiredError)
    end

    it "errors out if there is no provider" do
      lambda {
        Authenticator.find_or_create_user_from_auth_hash(nil, auth_hash)
      }.should raise_error(AuthProviderRequiredError)
    end

    it "searches Authentication for an auth by provider and uid" do
      Authentication.should_receive(:find_by_provider_and_uid).with("twitter", 9)
      Authenticator.find_or_create_user_from_auth_hash("twitter", auth_hash)
    end

    it "returns an existing user given an existing authentication" do
      user = authentication.user
      Authenticator.find_or_create_user_from_auth_hash("twitter", auth_hash).should == user
    end

    it "creates a new authentication if the authentication is new" do
      lambda {
        Authenticator.find_or_create_user_from_auth_hash("twitter", auth_hash)
      }.should change(Authentication, :count).by(1)
    end

    it "creates a new user if the authentication is new and returns it" do
      lambda {
        Authenticator.find_or_create_user_from_auth_hash("twitter", auth_hash)
      }.should change(User, :count).by(1)
    end
    
    it "returns the new user" do
      user = Authenticator.find_or_create_user_from_auth_hash("twitter", auth_hash)
      user.class.to_s.should == "User"
    end

  end

  context "creates a new authentication for an existing user" do

    let (:user) { Fabricate.build(:user) }

    it "breaks if there is no user" do
      lambda {
        Authenticator.add_authentication_to_user(nil, "twitter", auth_hash)
      }.should raise_error(UserRequiredError)
    end

    it "breaks if there is no auth_hash" do
      lambda {
        Authenticator.add_authentication_to_user(user, "twitter", nil);
      }.should raise_error(AuthHashRequiredError)
    end

    it "breaks if there is no provider" do
      lambda {
        Authenticator.add_authentication_to_user(user, nil, auth_hash)
      }.should raise_error(AuthProviderRequiredError)
    end

    it "updates a user's authentication if they already had that auth" do
      user = Authenticator.find_or_create_user_from_auth_hash("twitter", auth_hash)
       
      auth_hash["uid"] = 2342
      Authenticator.add_authentication_to_user(user, "twitter", auth_hash)
      user.authentication_by_provider("twitter").uid.should == "2342"
    end

    it "creates a new user authentication if it's new" do
      user.save!
      lambda {
        Authenticator.add_authentication_to_user(user, "twitter", auth_hash)
      }.should change(Authentication, :count).by(1)
    end

  end

end
