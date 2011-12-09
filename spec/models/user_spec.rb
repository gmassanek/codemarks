require 'spec_helper'

describe User do

  it "requires an email" do
    user = Fabricate.build(:user)
    user.email = nil
    user.should_not be_valid
  end

  context "passwords" do
    it "requires password and password_confirmation to be the same" do
      user = Fabricate.build(:user)
      user.password_confirmation = "password2"
      user.should_not be_valid
    end
  end

  context "#has_saved_link?(link)" do
    it "is true if a LinkSave record exists for that user and link" do
      link = Fabricate.build(:link)
      user = Fabricate.build(:user)
      user.stub!(:links).and_return([link])
      user.should be_has_saved_link(link)
    end
  end
end
