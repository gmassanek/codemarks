require 'fast_helper'

class LinkRecord; end
class FindTopics; end
class SomethingTaggable
  include Taggable

  def id
  end
end

describe Taggable do
  let(:title) { "Some title" }
  let(:body) { "that has text" }
  let(:taggable_instance) { SomethingTaggable.new }

  describe "#proposed_tags" do
    before do
      taggable_instance.stub!(title: title, body: body, :tagging_order => [:title, :body])
    end

    it "finds attributes to tag from tagging order method" do
      Tagger.should_receive(:tag).with(title)
      Tagger.should_receive(:tag).with(body)
      taggable_instance.proposed_tags
    end

    it "stops asking for tags if it's found 5" do
      Tagger.should_receive(:tag).with(title).and_return([1,2,3,4,5])
      Tagger.should_not_receive(:tag).with(body)
      taggable_instance.proposed_tags
    end

    it "combines tags from multiple attributes" do
      Tagger.should_receive(:tag).with(title).and_return([1,2,3])
      Tagger.should_receive(:tag).with(body).and_return([4,5])
      taggable_instance.proposed_tags.should == [1,2,3,4,5]
    end

    it "will only return 5" do
      Tagger.should_receive(:tag).with(title).and_return([1,2,3])
      Tagger.should_receive(:tag).with(body).and_return([4,5, 6, 7])
      taggable_instance.proposed_tags.should == [1,2,3,4,5]
    end

    it "will not return duplicates" do
      Tagger.should_receive(:tag).with(title).and_return([1,2,3])
      Tagger.should_receive(:tag).with(body).and_return([2, 3, 4])
      taggable_instance.proposed_tags.should == [1, 2, 3, 4]
    end

    it "returns the tags the tagger returns" do
      matching_topic = stub(:topic1)
      Tagger.stub!(:tag => [matching_topic])
      taggable_instance.proposed_tags.should == [matching_topic]
    end

    it "defers to existing_tags if the taggable item already exists" do
      FindTopics.stub(:existing_topics_for).and_return([1,2,3,4,5])
      LinkRecord.should_receive(:find).with(5)
      taggable_instance.stub(:id => 5)
      Tagger.should_not_receive(:tag)
      taggable_instance.proposed_tags
    end

    it "ignores existing_tags if there aren't enough" do
      FindTopics.stub(:existing_topics_for).and_return([])
      LinkRecord.should_receive(:find).with(5)
      taggable_instance.stub(:id => 5)
      Tagger.should_receive(:tag).and_return([1,2,3,4,5])
      taggable_instance.proposed_tags
    end
  end
  
  describe "#existing_tags" do
    it "finds all codemarks for that resource" do
      taggable_instance.stub(:id => 5)
      resource = stub
      LinkRecord.should_receive(:find).with(5).and_return(resource)
      FindTopics.should_receive(:existing_topics_for).with(resource)
      # TODO Should be the line below
      #FindTopics.should_receive(:existing_topics_for).with(SomethingTaggable, 5)
      taggable_instance.existing_tags
    end
  end

  describe "#taggable" do
    it "is taggable" do
      taggable_instance.should be_taggable
    end
  end
end
