require_relative '../../../app/models/codemarks/codemark'
require_relative '../../../app/models/codemarks/link'

class Link; end
class Topic; end

describe Codemarks::Codemark do
  let(:valid_url) { "http://www.example.com" }

  describe "#initialize" do
    it "creates and assigns a link on initialize" do
      Codemarks::Link.any_instance.stub(:tag => nil)
      link = Codemarks::Link.new
      Codemarks::Link.should_receive(:new).and_return(link)
      cm = Codemarks::Codemark.new
      cm.link.should == link
    end

    it "asks for and assigns tags" do
      #don't want to stub long chain of Codemarks::Link.new.tag
      example_topic = stub(title: "example")
      Topic.stub!(:all => [example_topic])
      cm = Codemarks::Codemark.new(valid_url)
      cm.tags.should == [example_topic]
    end

    it "asks for and assigns tags" do
      #too much stubbing here
      tags = stub
      link = Codemarks::Link.new
      link = stub(tag: tags)
      Codemarks::Link.stub!(new: link)
      cm = Codemarks::Codemark.new
      cm.tags.should == tags
    end
  end

  it "is taggable if it's link is taggable" do
    Codemarks::Link.any_instance.stub(:tag => nil)
    cm = Codemarks::Codemark.new
    cm.stub_chain(:link, :taggable?, true)
    cm.should be_taggable
  end

  describe "#commit", :skip => true do
    it "commits its link on commit" do
      Codemarks::Link.any_instance.stub(:tag => nil)
      Link.should_receive(:create)
      cm = Codemarks::Codemark.new
      cm.commit
    end
  end

end
