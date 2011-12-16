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

  context "#codemark_for?(link)" do
    it "is nil is there isn't one" do
      codemark = Fabricate(:codemark)
      user = Fabricate(:user)
      user.codemark_for(codemark.link).should be_nil
    end

    it "returns it if it exists" do
      codemark = Fabricate(:codemark)
      codemark.user.codemark_for(codemark.link).should == codemark
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

  it "topics are ones that I have added codemarks for" do
    my_topic = Fabricate(:topic)
    his_topic = Fabricate(:topic)
    codemark = Fabricate(:codemark, user: user, topics: [my_topic])
    user.topics.should == [my_topic]
  end
end
