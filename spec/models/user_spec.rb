require 'spec_helper'

describe User do

  #it "requires an email" do
  #  user = Fabricate.build(:user)
  #  user.email = nil
  #  user.should_not be_valid
  #end

  it "requires at least one authentication" do
    user = Fabricate.build(:user)
    user.authentications = nil
    user.should_not be_valid
  end

  context "#has_saved_link?(link)" do
    it "is true if a LinkSave record exists for that user and link" do
      link = Fabricate.build(:link)
      user = Fabricate.build(:user)
      user.stub!(:links).and_return([link])
      user.should be_has_saved_link(link)
    end
  end

  context "finds an authentication by provider" do
    it "if one exists" do
      user = Fabricate(:user)
      authentication = Fabricate(:authentication, user: user, provider: "twitter")
      user.authentication_by_provider("twitter").should == authentication
    end
    it "returns nil if there isn't one" do
      user = Fabricate(:user)
      user.authentication_by_provider("twitter").should be_nil
    end
  end
end
