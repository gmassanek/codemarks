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

  context "#has_saved_link?(link)" do
    it "is true if a LinkSave record exists for that user and link" do
      link = Fabricate.build(:link)
      user.stub!(:links).and_return([link])
      user.should be_has_saved_link(link)
    end
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
end
