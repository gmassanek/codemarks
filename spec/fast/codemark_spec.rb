require 'fast_helper'

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

    it "saves a note" do
      attributes = { :note => "Some Note" }
      codemark = Codemark.new(attributes)
      codemark.note.should == "Some Note"
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
      @note = "Some Note"

      codemark_record = mock({
        resource: @resource,
        topics: @tags,
        user: @user,
        title: @title,
        note: @note,
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

    xit "extracts the user of it's codemark_record" do
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

    it"comes from it's instance variable first" do
      codemark = Codemark.new(title: title)
      codemark.title.should == title
    end

    it "if there is no title, it gets it from it's resource" do
      resource = mock(title: title)
      codemark = Codemark.new(resource: resource)
      codemark.title.should == title
    end
  end

  describe '#save' do
    it 'sets resource author to mine if no other codemarks for it exist yet' do
      resource = mock(:author => nil)
      user = mock(:id => 13)

      codemark = Codemark.new
      codemark.user = user
      codemark.resource = resource

      codemark.should_receive(:save_to_database)
      codemark.should_receive(:load_users_codemark)
      codemark.save
    end
  end

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
end

