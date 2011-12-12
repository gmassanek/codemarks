require 'spec_helper'

describe Topic do
  
  describe "validations" do
    let(:topic) { Fabricate.build(:topic) }

    it "requires a title" do
      topic.title = nil
      topic.should_not be_valid
    end

    it "needs a unique title" do
      dup_topic = Fabricate.build(:topic, :title => topic.title)
      topic.save
      dup_topic.should_not be_valid
    end

    it "is global by default" do
      topic.save!
      topic.global.should == true
    end
  end

  #describe "scopes" do
  #  before do
  #    @lt = Fabricate(:link_topic)
  #    @lt2 = Fabricate(:link_topic, :topic => @lt.topic)
  #    @alt = Fabricate(:link_topic)
  #    @plt = Fabricate(:private_link_topic)
  #  end
  #  let(:user) { Fabricate(:user_with_private_link) }
  #  let(:user2) { Fabricate(:user) }

  #  it "gets all public links" do
  #    Topic.all_public.collect(&:id).should == [@lt.topic, @alt.topic].collect(&:id)
  #  end

  #  it "gets all public links plus user's private links" do
  #    Topic.public_and_for_user(user).collect(&:id).should =~ user.topics.collect(&:id) | Topic.all_public.collect(&:id)
  #  end

  #  it "gets all a user's private links if there is a user and is filtered" do
  #    Topic.for_user(user).should == user.topics
  #  end

  #  context "resource counts" do
  #    it "gives count of all public links if there is no user"
  #    it "gives count of all public links plus user's private links if there is a user, not filtered"
  #    it "gives count of all a user's private links if there is a user and is filtered"
  #  end
  #end
end
