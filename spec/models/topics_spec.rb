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

end
