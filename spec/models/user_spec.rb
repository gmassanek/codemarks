require 'spec_helper'

describe User do

  let(:user) { Fabricate(:user) }
  let!(:authentication) { user.authentications.first }

  it "requires at least one authentication"

  it "has a nickname after save" do
    user.update_attribute(:nickname, nil)
    user.nickname.should_not be_nil
  end

  context "finds an authentication by provider" do
    it "if one exists" do
      user.authentication_by_provider("twitter").should == authentication
    end

    it "returns nil if there isn't one" do
      user.authentication_by_provider("another_servica").should be_nil
    end
  end

  it "deletes all authentications when I delete a user" do
    expect do
      user.destroy
    end.to change(Authentication, :count).by(-1)
  end

  it "knows which authentications it's missing" do
    authentication = Fabricate(:authentication, user: user, provider: "twitter")
    user.missing_authentications.should include(:github)
  end

  context "grabs extra information from it's authentications" do
    it "uses an authentication name if none has been explicitly set on the user" do
      authentication.update_attribute(:name, "John Smith")
      user.get(:name).should == "John Smith"
    end

    it "uses the user name field if it has one" do
      user.name = "Pete Hodges"
      user.save
      user.get(:name).should == "Pete Hodges"
    end
  end

  it "finds users by email through authentications" do
    user = Fabricate(:user)
    authentication = user.authentications.first
    user.authentication_by_provider(:twitter).provider.should == "twitter"
    found_user = User.find_by_email(authentication.email)
    found_user.should == user
    found_user.get(:email).should == authentication.email
  end

  it "should destroy it's codemarks" do
    Fabricate(:codemark_record, :user => user)
    expect {
      user.destroy
    }.should change(CodemarkRecord, :count).by(-1)
  end

  it "finds a user by authenticaion and username" do
    user = Fabricate(:user)
    authentication = user.authentications.first
    provider = authentication.provider
    nickname = authentication.nickname

    User.find_by_authentication(provider, nickname).should == user
  end
end
