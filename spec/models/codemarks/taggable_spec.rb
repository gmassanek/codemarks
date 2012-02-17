require_relative '../../../app/models/codemarks/taggable'
require_relative '../../../app/models/codemarks/tagger'

include Codemarks

class SomethingTaggable
  include Taggable
end

describe Taggable do
  let(:title) { "Some title" }
  let(:body) { "that has text" }
  let(:taggable_instance) { SomethingTaggable.new }

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

  it "is taggable" do
    taggable_instance.should be_taggable
  end
end
