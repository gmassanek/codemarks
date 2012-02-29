require 'spec_helper'

describe Topic do
  describe "validations" do
    let(:topic) { Fabricate.build(:topic) }

    it "requires a title" do
      topic.title = nil
      topic.should_not be_valid
    end

    it "needs a unique title if it doesn't have a user_id" do
      dup_topic = Fabricate.build(:topic, :title => topic.title)
      topic.save
      dup_topic.should_not be_valid
    end

    it "can be a duplicate title if they all have a different user_id" do
      dup_topic = Fabricate.build(:topic, title: topic.title, user: Fabricate(:user))
      topic.save
      dup_topic.should be_valid
    end

    it "is global by default" do
      topic.save!
      topic.global.should == true
    end
  end

  it "returns all associated codemarks" do
    codemark = Fabricate(:codemark_record)
    topic = codemark.topics.first
    codemark2 = Fabricate(:codemark_record, topics: [topic])
    topic.codemark_records.should == [codemark, codemark2]
  end
end
