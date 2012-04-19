require 'fast_helper'

describe Link do
  let(:valid_url) { "http://www.example.com" }

  describe "#initialize" do
    it "saves an id" do
      attributes = { :id => 999 }
      link = Link.new(attributes)
      link.id.should == 999
    end

    it "saves a url" do
      attributes = { :url => 'http://www.google.com' }
      link = Link.new(attributes)
      link.url.should == 'http://www.google.com'
    end
  end

  describe "#self.load" do
    it "creates a new Link from given attributes and loads it up" do
      attributes = stub
      link = stub
      Link.should_receive(:new).with(attributes).and_return(link)
      link.should_receive(:load)
      Link.load(attributes)
    end
  end

  describe "#load" do
    it "loads it's link_record" do
      link = Link.new
      link.should_receive(:load_link_record)
      link.load
    end
  end

  describe "#load_link_record" do
    it "caches in memory (returns from @link_record)" do
      link = Link.new

      link_record = stub
      link.link_record = link_record

      link.load_link_record.should == link_record
    end

    it "caches in the db (returns from find_link_record)" do
      link = Link.new

      link_record = stub.as_null_object
      link.should_receive(:find_existing_link_record).and_return(link_record)
      link.load_link_record.should == link_record
    end

    it "resorts to the WWW" do
      link = Link.new

      link_record = stub.as_null_object
      link.stub(:find_existing_link_record)
      link.should_receive(:create_link_record_from_internet).and_return(link_record)
      link.load_link_record.should == link_record
    end

    it "loads it's other attributes if it wasn't already" do
      link_record = mock({
        :id => 32,
        :url => 'http://www.hotmail.com',
        :title => 'Hotmail',
        :host => 'www.hotmail.com',
        :html_content => 'This stuff over here'
      })

      link = Link.new
      link.stub(:find_existing_link_record) { link_record }
      link.load_link_record

      link.id.should == 32
      link.url.should == 'http://www.hotmail.com'
      link.title.should == 'Hotmail'
      link.host.should == 'www.hotmail.com'
      link.html_content.should == 'This stuff over here'
    end
  end

  describe "#find_existing_link_record" do
    it "is nil if there is no id or url" do
      link = Link.new
      link.find_existing_link_record.should be_nil
    end

    it "looks for LinkRecord by id first" do
      link_record = stub
      link = Link.new(:id => 2234)
      Link.should_receive(:find_link_record_by_id).with(2234).and_return(link_record)
      link.find_existing_link_record.should == link_record
    end

    it "searches LinkRecords by url" do
      link_record = stub
      link = Link.new(:id => nil, :url => 'some_url')
      Link.should_receive(:find_link_record_by_url).with('some_url').and_return(link_record)
      link.find_existing_link_record.should == link_record
    end
  end

  describe "create_link_record_from_internet" do
    it "reaches out to the internet and doesn't break - refacor pleace"
  end

  describe "is taggable" do
    it "has a tagging order" do
      link = Link.new
      link.tagging_order.should == [:title, :html_content]
    end

    it "has a tags method" do
      link = Link.new
      link.should respond_to(:tags)
    end
  end
end
