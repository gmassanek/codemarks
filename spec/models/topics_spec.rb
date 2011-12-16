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

  it "returns all associated codemarks" do
    codemark = Fabricate(:codemark)
    topic = codemark.topics.first
    codemark2 = Fabricate(:codemark, topics: [topic])
    topic.codemarks.should == [codemark, codemark2]
  end
end
