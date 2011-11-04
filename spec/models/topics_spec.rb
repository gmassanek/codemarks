require 'spec_helper'

describe Topic do
  
  describe "validations" do
    let(:topic) { Fabricate.build(:topic) }

    it "requires a title" do
      topic.title = nil
      topic.should_not be_valid
    end

    it "needs a unique title" do
      topic.save
      dup_topic = Fabricate.build(:topic, :title => topic.title)
      dup_topic.should_not be_valid
    end
  end

  describe "resrouces" do 
    it "has 0 sponsored_sites as a new topic" do
      topic  = Fabricate(:topic)
      topic.sponsored_sites.should be_empty
    end
  end

end
