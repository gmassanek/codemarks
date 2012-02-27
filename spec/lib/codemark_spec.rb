require 'fast_helper'

class Topic; end
class LinkRecord; end
class CodemarkRecord; end

describe Codemark do
  let(:valid_url) { "http://www.example.com" }

  describe "#prepare" do
    it "builds and assigns a link(resource) if type is link" do
      link = stub(:tag => nil, :proposed_tags => nil)
      resource_attrs = {}
      Link.should_receive(:new).with(resource_attrs).and_return(link)
      cm = Codemark.prepare(:link, resource_attrs)
      cm.resource.should == link
    end

    it "asks for tags" do
      link = stub(:tag => nil)
      Link.stub(:new => link)
      link.should_receive(:proposed_tags)
      Codemark.prepare(:link, {})
    end
  end

  it "is taggable if it's resource is taggable" do
    cm = Codemark.prepare(:link, {})
    link = stub(:taggable? => true)
    cm.stub!(:resource => link)
    cm.should be_taggable
  end

  describe "#create" do
    it "creates a link (resource)" do
      resource_attrs = {}
      CodemarkRecord.stub!(:create)
      LinkRecord.should_receive(:create).with(resource_attrs)
      Codemark.create({:type => :link}, resource_attrs, {"22" => "22"}, stub)
    end

    it "unless it is an existing link"

    it "creates new topics if the topic has not been saved before"
    it "makes a new CodemarkRecord" do
      user = stub
      topics = {"1" => 1}
      link = stub(:id => 1)
      LinkRecord.stub!(:create => link)

      codemark_attrs = {:type => :link}
      full_attrs = {:type => :link, :link_record => link, :topic_ids => ["1"], :user => user}

      CodemarkRecord.should_receive(:create).with(full_attrs)
      Codemark.create(codemark_attrs, {}, topics, user)
    end
    it "creates or gathers tags"
  end
end
