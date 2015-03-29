require 'spec_helper'

describe CodemarksTopic do
  it "has a codemark and a topic" do
    codemark_topic = Fabricate.build(:codemarks_topic)
    codemark_topic.codemark.should_not be_nil
    codemark_topic.topic.should_not be_nil
  end
end

