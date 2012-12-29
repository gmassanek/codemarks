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
      attributes = { :url => 'http://www.google.com/' }
      link = Link.new(attributes)
      link.url.should == 'http://www.google.com/'
    end

    it 'normalized the url' do
      Link.stub(:normalize => 'clean_url')
      link = Link.new(:url => 'http://www.google.com')
      link.url.should == 'clean_url'
    end

    it "saves an author_id" do
      attributes = { :author_id => 3 }
      link = Link.new(attributes)
      link.author_id.should == 3
    end
  end

  describe 'normalize' do
    it 'returns nil if blank' do
      Link.normalize('').should be_nil
    end

    it 'ensures trailing slashes' do
      Link.normalize('http://www.google.com').should == 'http://www.google.com/'
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
        :author_id => 3,
        :site_data => 'This stuff over here'
      })

      link = Link.new
      link.stub(:find_existing_link_record) { link_record }
      link.load_link_record

      link.id.should == 32
      link.url.should == 'http://www.hotmail.com'
      link.title.should == 'Hotmail'
      link.host.should == 'www.hotmail.com'
      link.author_id.should == 3
      link.site_data.should == 'This stuff over here'
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
    it "reaches out to the internet and doesn't break - refactor please"
  end

  describe "is taggable" do
    it "has a tagging order" do
      link = Link.new
      link.tagging_order.should == [:title, :site_data]
    end

    it "has a tags method" do
      link = Link.new
      link.should respond_to(:tags)
    end
  end

  describe '#orphan?' do
    it 'is true if it has no author' do
      link = Link.new
      link.should be_orphan
    end

    it 'is false if it has an author' do
      link = Link.new
      link.author_id = 34
      link.should_not be_orphan
    end
  end

  describe '#update_author' do
    it 'updates the link_record author if it is an orphan' do
      link = Link.new
      link.stub(:'orphan?') { true }
      link.should_receive(:persist_author)
      link.update_author(8)
      link.author_id.should == 8
    end

    it 'updates the link_record author if it is an orphan' do
      link = Link.new(:author_id => 8)
      link.stub(:'orphan?') { true }
      link.should_receive(:persist_author)
      link.update_author
    end

    it 'does not update the link_record author if it is not an orphan' do
      link = Link.new
      link.stub(:'orphan?') { false }
      link.should_not_receive(:persist_author)
      link.update_author(8)
    end
  end
end
