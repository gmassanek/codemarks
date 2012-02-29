require 'spec_helper'

describe User do

  #it "requires an email" do
  #  user = Fabricate.build(:user)
  #  user.email = nil
  #  user.should_not be_valid
  #end

  let(:user) { authenticated_user }

  it "requires at least one authentication", broken: true do
    # TODO Broken because of fabrications
    user.should_not be_valid
  end

  context "finds an authentication by provider" do
    it "if one exists" do
      authentication = Fabricate(:authentication, user: user, provider: "twitter")
      user.authentication_by_provider("twitter").should == authentication
    end
    it "returns nil if there isn't one" do
      user.authentication_by_provider("twitter").should be_nil
    end
  end

  it "deletes all authentications when I delete a user" do
    authentication = Fabricate(:authentication, user: user, provider: "twitter")
    authentication.user.destroy
    Authentication.find_by_id(authentication.id).should == nil
  end

  it "knows which authentications it's missing" do
    authentication = Fabricate(:authentication, user: user, provider: "twitter")
    user.missing_authentications.should include(:github)
  end

  context "grabs extra information from it's authentications" do
    it "uses an authentication name if none has been explicitly set on the user" do
      authentication = Fabricate(:authentication, user: user, provider: "twitter", name: "John Smith")
      user.get(:name).should == "John Smith"
    end

    it "uses the user name field if it has one" do
      user.name = "Pete Hodges"
      user.save
      user.get(:name).should == "Pete Hodges"
    end
  end

  it "finds users by email through authentications" do
    authentication = Fabricate(:authentication)
    user = authentication.user
    user.authentication_by_provider(:twitter).provider.should == "twitter"
    found_user = User.find_by_email(authentication.email)
    found_user.should == user
    found_user.get(:email).should == authentication.email
  end
end
