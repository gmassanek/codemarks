require 'fast_helper'

class Topic; end
class LinkRecord
  def self.find_by_id(id)
  end
  def self.find_by_url(url)
  end
end
class CodemarkRecord; end

describe Codemark do
  let(:valid_url) { "http://www.example.com" }

  describe "#prepare" do
      let(:resource_attrs) { {} }

    it "prepares a new resource if it doesn't already exist" do
      link = stub(:tag => nil, :proposed_tags => nil)
      Link.should_receive(:new).with(resource_attrs).and_return(link)
      cm = Codemark.prepare(:link, resource_attrs)
      cm.resource.should == link
    end

    it "asks the new resource for proposed tags" do
      link = stub(:tag => nil)
      Link.stub(:new => link)
      link.should_receive(:proposed_tags)
      Codemark.prepare(:link, {})
    end

    context "when a resource already exists" do
      let(:link) { Link.new(resource_attrs) }

      it "gets returned" do
        Link.should_receive(:find).with(resource_attrs).and_return(link)
        link.stub_chain(:proposed_tags, :length => 2)
        Link.should_not_receive(:new)
        cm = Codemark.prepare(:link, resource_attrs)
        cm.resource.should == link
      end

      it "gets topics from existing codemarks for that resource" do
        Link.should_receive(:find).with(resource_attrs).and_return(link)
        link.stub_chain(:proposed_tags, :length => 2)
        Link.should_not_receive(:new)
        cm = Codemark.prepare(:link, resource_attrs)
        cm.resource.should == link
      end
    end
  end

  it "is taggable if it's resource is taggable" do
    cm = Codemark.prepare(:link, {})
    link = stub(:taggable? => true)
    cm.stub!(:resource => link)
    cm.should be_taggable
  end

  describe "#create" do
    it "creates a link resource" do
      resource_attrs = {}
      CodemarkRecord.stub!(:create)
      CodemarkRecord.stub!(:for_user_and_link)
      LinkRecord.should_receive(:create).with(resource_attrs)
      Codemark.create({:type => :link}, resource_attrs, [22], stub)
    end

    it "makes a new CodemarkRecord" do
      user = stub
      topic_ids = [1]
      link = stub(:id => 1)
      LinkRecord.stub!(:create => link)

      codemark_attrs = {:type => :link}
      full_attrs = {:type => :link, :link_record => link, :topic_ids => [1], :user => user}

      CodemarkRecord.stub!(:for_user_and_link)
      CodemarkRecord.should_receive(:create).with(full_attrs)
      Codemark.create(codemark_attrs, {}, topic_ids, user)
    end

    it "creates new topics if the topic has not been saved before" do
      user = stub
      topic_ids = [1]
      link = stub(:id => 1)
      LinkRecord.stub!(:create => link)

      codemark_attrs = {:type => :link}
      topic_stub = stub(:topic, :id => 99)
      full_attrs = {:type => :link, :link_record => link, :topic_ids => [1, 99], :user => user}

      Topic.should_receive(:create!).with(:title => "backbone").and_return(topic_stub)
      CodemarkRecord.should_receive(:create).with(full_attrs)
      CodemarkRecord.stub!(:for_user_and_link)
      Codemark.create(codemark_attrs, {}, topic_ids, user, :new_topic_titles => ["backbone"])
    end

    context "when a resource already exists" do
      let(:resource_attrs) { {:id => 4} }
      let(:link) { Link.new(resource_attrs) }

      it "uses the existing resource" do
        user = stub
        link_record = LinkRecord.new
        LinkRecord.should_receive(:find_by_id).with(resource_attrs[:id]).and_return(link_record)
        Link.should_not_receive(:create)

        codemark_attrs = {:type => :link}
        full_attrs = {:type => :link, :link_record => link, :topic_ids => [1], :user => user}

        CodemarkRecord.stub(:create)
        CodemarkRecord.stub!(:for_user_and_link)
        Codemark.create(codemark_attrs, resource_attrs, [1], user)
      end
    end
    it "creates or gathers tags"
  end

  describe "#build_and_create" do
    it "creates a codemark" do
      Topic.stub(:all => [])
      user = stub
      LinkRecord.should_receive(:create)
      CodemarkRecord.should_receive(:create)
      CodemarkRecord.stub!(:for_user_and_link)
      Codemark.build_and_create(user, :link, :url => valid_url)
    end

    it "doesn't save a second link"
  end

  describe "#steal" do
    it "copies someone else's codemark for me" do
      user = stub
      codemark_record = stub(:topic_ids => [1,2,3], :link_record_id => 1)
      CodemarkRecord.should_receive(:create).with(:user => user, :link_record_id => 1, :topic_ids => [1,2,3])
      Codemark.steal(codemark_record, user)
    end
  end
end
