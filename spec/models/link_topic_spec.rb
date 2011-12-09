require 'spec_helper'

describe LinkTopic do

  context "requires" do
    [:link, :topic, :user].each do |field|
      it "a #{field}" do
        link_topic = Fabricate.build(:link_topic, field => nil)
        link_topic.should_not be_valid
      end
    end
  end

  it "has a user" do 
    link_topic = Fabricate(:link_topic)
    LinkTopic.last.user.class.to_s.should == "User"
  end
end
