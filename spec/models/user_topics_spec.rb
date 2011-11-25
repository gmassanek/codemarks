require 'spec_helper'

describe UserTopic do

  let (:user_topic) { Fabricate.build(:user_topic) }

  it "requires a user" do
    user_topic.user = nil
    user_topic.should_not be_valid
  end

  it "requires a topic" do
    user_topic.topic = nil
    user_topic.should_not be_valid
  end

end
