require_relative '../../../app/models/codemarks/taggable'

class SomethingTaggable
  include Codemarks::Taggable
end

describe Codemarks::Taggable do
  let(:title) { "Some title" }
  let(:body) { "that has text" }

  it "examines the attributes of it's parent in tagging order" do
    taggable_instance = SomethingTaggable.new
    taggable_instance.stub!(title: title, body: body, :tagging_order => [:title, :body])
    Codemarks::Tagger.should_receive(:tag).with(title)
    Codemarks::Tagger.should_receive(:tag).with(body)
    taggable_instance.proposed_tags
  end

  it "returns the tags the tagger returns" do
    matching_topic = stub(:topic1)
    Codemarks::Tagger.stub!(:tag => [matching_topic])
    taggable_instance = SomethingTaggable.new
    taggable_instance.stub!(title: title, body: body, :tagging_order => [:title, :body])
    taggable_instance.proposed_tags.should == [matching_topic]
  end

  it "is taggable" do
    SomethingTaggable.new.should be_taggable
  end
end
