require 'spec_helper'

describe CodemarkTopic do
  it "has a codemark and a topic" do
    codemark_topic = Fabricate.build(:codemark_topic)
    codemark_topic.codemark_record.should_not be_nil
    codemark_topic.topic.should_not be_nil
  end
end

