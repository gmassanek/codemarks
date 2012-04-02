require 'fast_helper'

# Resource (Link)
# Tags/Topics
# Persistance layer (CodemarkRecord)

describe Codemark do

  describe "#initialize" do
    it "saves an id" do
      attributes = { :id => 999 }
      codemark = Codemark.new(attributes)
      codemark.id.should == 999
    end

    it "saves a resource" do
      resource = stub
      attributes = { :resource => resource }
      codemark = Codemark.new(attributes)
      codemark.resource.should == resource
    end

    it "saves tags" do
      tags = [stub, stub]
      attributes = { :tags => tags }
      codemark = Codemark.new(attributes)
      codemark.tags.should == tags
    end

    it "saves a user" do
      user = [stub, stub]
      attributes = { :user => user }
      codemark = Codemark.new(attributes)
      codemark.user.should == user
    end

    it "saves a codemark_record" do
      codemark_record = stub
      attributes = { :codemark_record => codemark_record }
      codemark = Codemark.new(attributes)
      codemark.codemark_record.should == codemark_record
    end

    it "saves a title" do
      attributes = { :title => "Some Title" }
      codemark = Codemark.new(attributes)
      codemark.title.should == "Some Title"
    end

    describe "saves resource attributes like" do
      it "url" do
        attributes = { :url => "some_url" }
        codemark = Codemark.new(attributes)
        codemark.url.should == "some_url"
      end
    end
  end

  describe "#self.load" do
    it "creates a new Codemark" do
      codemark = stub
      Codemark.should_receive(:new).and_return(codemark)
      codemark.should_receive(:load)
      Codemark.load
    end

    it "passes attributes to new" do
      attributes = stub
      codemark = stub
      Codemark.should_receive(:new).with(attributes).and_return(codemark)
      codemark.should_receive(:load)
      Codemark.load(attributes)
    end
  end

  describe "#load" do
    it "looks in persistance and be done with it" do
      codemark = Codemark.new(:id => 122)
      codemark.should_receive(:load_requested_codemark).and_return(stub)
      codemark.should_not_receive(:load_link)
      codemark.load
    end

    it "loads the link if it didn't get a codemark yet" do
      link = stub
      codemark = Codemark.new
      codemark.should_receive(:load_link).and_return(link)
      codemark.load
      codemark.resource.should == link
    end

    it "looks for a codemark for that user/link if there is a user" do
      link = stub
      codemark = Codemark.new
      codemark.stub(:load_link)
      codemark.should_receive(:load_users_codemark)
      codemark.load
    end
  end

  describe "#load_requested_codemark" do
    it "loads codemark from persistance and steals it's attributes" do
      codemark = Codemark.new(:id => 122)
      codemark.should_receive(:load_codemark_by_id).with(122).and_return(stub)
      codemark.should_receive(:pull_up_attributes)
      codemark.load_requested_codemark
    end

    it "doesn't bother with persistance without an id" do
      codemark = Codemark.new
      codemark.should_not_receive(:load_codemark_by_id)
      codemark.should_not_receive(:pull_up_attributes)
      codemark.load_requested_codemark
    end

    it "returns true if it found a codemark" do
      codemark = Codemark.new(:id => 122)
      codemark.stub(:load_codemark_by_id).and_return(stub)
      codemark.stub(:pull_up_attributes)
      codemark.load_requested_codemark.should == true
    end
  end

  describe "#load_users_codemark" do
    let(:user) { stub }
    let(:resource) { stub }

    it "loads codemark from persistance and steals their attributes" do
      codemark = Codemark.new(user: user, resource: resource)
      codemark.should_receive(:load_codemark_for_user).and_return(stub)
      codemark.should_receive(:pull_up_attributes)
      codemark.load_users_codemark
    end

    it "doesn't bother with persistance without a user" do
      codemark = Codemark.new(resource: resource)
      codemark.should_not_receive(:pull_up_attributes)
      codemark.load_users_codemark
    end

    it "doesn't bother with persistance without a link" do
      codemark = Codemark.new(user: user)
      codemark.should_not_receive(:pull_up_attributes)
      codemark.load_users_codemark
    end
  end

  describe "#pull_up_attributes" do
    before do
      @resource = stub
      @tags = [stub, stub]
      @user = stub
      @title = "Some Title"

      codemark_record = mock({
        link_record: @resource,
        topics: @tags,
        user: @user,
        title: @title,
        id: 3
      })

      @codemark = Codemark.new(codemark_record: codemark_record)
      @codemark.pull_up_attributes
    end

    it "extracts the resource of it's codemark_record" do
      @codemark.resource.should == @resource
    end

    it "extracts the tags of it's codemark_record" do
      @codemark.tags.should == @tags
    end

    it "extracts the user of it's codemark_record" do
      @codemark.user.should == @user
    end

    it "extracts the title of it's codemark_record" do
      @codemark.title.should == @title
    end
  end

  describe "#tags" do
    let(:tags) { [stub, stub] }

    it "comes from it's instance variable first" do
      codemark = Codemark.new(tags: tags)
      codemark.tags.should == tags
    end

    it "if there are no tags, it gets them from it's resource" do
      tags = [stub, stub]
      resource = mock(tags: tags)
      codemark = Codemark.new(resource: resource)
      codemark.tags.should == tags
    end
  end

  describe "#title" do
    let(:title) { "Some Title" }

    it "comes from it's instance variable first" do
      codemark = Codemark.new(title: title)
      codemark.title.should == title
    end

    it "if there is no title, it gets it from it's resource" do
      resource = mock(title: title)
      codemark = Codemark.new(resource: resource)
      codemark.title.should == title
    end
  end

  it "# tag_ids "

  describe "#self.save" do
    it "loads a codemark from attributes" do
      attributes = stub
      tag_ids = []
      codemark = Codemark.new(:tag_ids => tag_ids)
      Codemark.should_receive(:load).with(attributes).and_return(codemark)
      Codemark.stub(:handle_new_topics) { [] }
      Codemark.stub(:look_for_user)
      codemark.stub(:save_to_database)
      Codemark.save(attributes, tag_ids)
    end
  end

  describe "#self.handle_new_topics(new_topics)" do
    it "returns an array of topic_ids"
    it "is [] if nothing exists"
  end

  describe "#look for user(:user_id, :email_address)" do
    it "can be nil"
    it "looks for a user id if there is one"
    it "looks for an email address if there is one"
  end

  describe "#save" do
    it "saves it's resource_id"
    it "saves it's resource_type"
    it "saves it's topic_ids"
    it "saves it's user_id"
    it "saves it's title"
  end


#Codemark
#  # save(attributes, tag_ids, :new_topics, :user_id, :email)
#    // attributes should have :link_id, 
#    codemark = Codemark.load(attributes)
#    tag_ids << handle_new_topics
#                 normalize
#                 match with existing?
#                 create
#    user
#    codemark.tag_ids = tag_ids
#    save_codemark_record


  describe "#build_and_create" do
    xit "creates a codemark" do
      Topic.stub(:all => [])
      user = stub
      link = Link.new
      link.stub({
        :tags => []
      })
      Link.should_receive(:new).and_return(link)
      LinkRecord.should_receive(:create)
      CodemarkRecord.should_receive(:create)
      CodemarkRecord.stub!(:for_user_and_link)
      Codemark.build_and_create(user, :link, :url => valid_url)
    end

    it "doesn't save a second link"
  end

  describe "#steal" do
    xit "copies someone else's codemark for me" do
      user = stub
      codemark_record = stub(:topic_ids => [1,2,3], :link_record_id => 1)
      CodemarkRecord.should_receive(:create).with(:user => user, :link_record_id => 1, :topic_ids => [1,2,3])
      Codemark.steal(codemark_record, user)
    end
  end

  describe "#resource_class" do
    xit "knows it's resource object class from it's resource_type" do
      resource_attrs = {}
      Codemark.any_instance.stub(:load_resource) { link }
      codemark = Codemark.new(:link, resource_attrs)
      codemark.resource_class.should == Link
    end
  end

  describe "#resource" do
    xit "knows it's resource object class from it's resource_type" do
      resource_attrs = {}
      Codemark.any_instance.stub(:load_resource) { link }
      codemark = Codemark.new(:link, resource_attrs)
      codemark.resource_class.should == Link
    end
  end
end

