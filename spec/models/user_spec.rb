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

  describe '#favorite_topics' do
    let(:user) { Fabricate(:user) }
    let(:topic1) { Fabricate(:topic) }
    let(:topic2) { Fabricate(:topic) }
    let(:topic3) { Fabricate(:topic) }

    it 'is nil if there are no codemarks' do
      user.favorite_topics.should be_nil
    end

    it 'is nil if none of the codemarks have topics' do
      codemark = Fabricate(:codemark_record, :user => user)
      user.favorite_topics.should be_nil
    end

    it 'includes topics from all codemarks' do
      codemark = Fabricate(:codemark_record, :user => user, :topics => [topic1])
      codemark = Fabricate(:codemark_record, :user => user, :topics => [topic2])
      user.favorite_topics.count.should == 2
    end

    it 'counts the codemarks for each topic' do
      Fabricate(:codemark_record, :user => user, :topics => [topic1, topic2])
      Fabricate(:codemark_record, :user => user, :topics => [topic1, topic2])
      Fabricate(:codemark_record, :user => user, :topics => [topic2, topic3])
      user.favorite_topics[topic1].should == 2
      user.favorite_topics[topic2].should == 3
      user.favorite_topics[topic3].should == 1
    end

    it 'orders them by count' do
      Fabricate(:codemark_record, :user => user, :topics => [topic1, topic2])
      Fabricate(:codemark_record, :user => user, :topics => [topic1, topic2])
      Fabricate(:codemark_record, :user => user, :topics => [topic2, topic3])
      user.favorite_topics.keys[0].should == topic2
      user.favorite_topics.keys[1].should == topic1
      user.favorite_topics.keys[2].should == topic3
    end

    it 'only shows the top 15' do
      topics = []
      17.times do
        topics << Fabricate(:topic)
      end
      Fabricate(:codemark_record, :user => user, :topics => topics)
      user.favorite_topics.length.should == 15
    end
  end
end
