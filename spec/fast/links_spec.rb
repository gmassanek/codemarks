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

  describe "load_from_internet" do
    it "is nil if there is no url" do
      link = Link.new
      link.create_link_record_from_internet.should be_nil
    end

    xit "fetches a parsed html response" do
      link = Link.new
      url = stub
      link.url = url
      link.should_receive(:parsed_html_response).with(url)
      link.create_link_record_from_internet
    end

    invalid_urls = ["twitter.com", "twitter", "www.twitter.com"]
    invalid_urls.each do |url|
      xit "is nil for invalid urls like #{url}" do
        link = Link.new({ :url => url })
        link.site_response.should be_nil
        link.should_not be_valid_url
      end
    end

    it "saves the LinkRecord"
    it "normalizes the url"
    it "saves it's attributes"
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

#  describe "#load_link_record_attributes" do
#    let(:link_record) { mock(:id => 4, 
#                         :url => 'http://www.twitter.com',
#                         :host => 'twitter.com',
#                         :title => 'Twitter') }
#    before do
#      Link.stub(:find_link_record) { stub }
#      Link.any_instance.stub(:load_link_record_attributes) { nil }
#
#      @link = Link.new
#      @link.stub!(:link_record) { link_record }
#    end
#
#    xit "extracts the url" do
#      @link = @link.load_link_record_attributes
#      @link.url.should == 'http://www.twitter.com'
#    end
#
#    xit "extracts the host" do
#      @link.load_link_record_attributes
#      @link.host.should == 'twitter.com'
#    end
#
#    xit "extracts the title" do
#      @link.load_link_record_attributes
#      @link.title.should == 'Twitter'
#    end
#
#    xit "extracts the id" do
#      @link.load_link_record_attributes
#      @link.id.should == 4
#    end
#  end
#
#  describe "#resource_attrs" do
#    let(:resource_attrs) { {} }
#
#    it "includes title" do
#      link = Link.new(resource_attrs)
#      link.resource_attrs.keys.should include(:title)
#    end
#
#    it "includes url" do
#      link = Link.new(resource_attrs)
#      link.resource_attrs.keys.should include(:url)
#    end
#
#    it "includes host" do
#      link = Link.new(resource_attrs)
#      link.resource_attrs.keys.should include(:host)
#    end
#  end
