require 'fast_helper'

describe Link do
  let(:valid_url) { "http://www.example.com" }
  let(:resource_attrs) { { url: valid_url } }
  let(:link_record) { stub(:link_record, :id => 4, 
                                  :url => 'http://www.twitter.com',
                                  :host => 'twitter.com',
                                  :title => 'Twitter') }

  describe "#create" do
    it "creates a link record in the database" do
      LinkRecord.should_receive(:create)
      Link.create({})
    end
  end

  describe "#find" do
    it "searches LinkRecords by url" do
      LinkRecord.should_receive(:find_by_url).with(valid_url).and_return(link_record)
      Link.find(resource_attrs)
    end

    it "returns a Link not a LinkRecord" do
      link_record = LinkRecord.new
      LinkRecord.stub(:find_by_url => link_record)
      Link.should_receive(:from_link_record).with(link_record)
      Link.find(resource_attrs)
    end
  end

  describe "#from_link_record" do
    it "turns a LinkRecord into a Link" do
      link = Link.from_link_record(link_record)
      link.should be_a(Link)
      link.url.should == 'http://www.twitter.com'
      link.id.should == 4
    end
  end

  describe "#resource_attrs" do
    it "includes title" do
      link = Link.new(resource_attrs)
      link.resource_attrs.keys.should include(:title)
    end

    it "includes url" do
      link = Link.new(resource_attrs)
      link.resource_attrs.keys.should include(:url)
    end

    it "includes host" do
      link = Link.new(resource_attrs)
      link.resource_attrs.keys.should include(:host)
    end
  end

  describe "#initialize" do
    # TODO Make these offline tests - probably perfect for VCR
    # TODO analyze the stubbing here - might need wrapper class for URI
    it "sets the link's url" do
      link = Link.new(resource_attrs)
      link.url.should == valid_url
    end

    describe "#gathers_site_response" do
      it "is non-nil for valid urls" do
        link = Link.new(resource_attrs)
        link.should be_valid_url
      end

      invalid_urls = ["twitter.com", "twitter", "www.twitter.com"]
      invalid_urls.each do |url|
        it "is nil for invalid urls like #{url}" do
          link = Link.new({ :url => url })
          link.site_response.should be_nil
          link.should_not be_valid_url
        end
      end
    end

    describe "#parse_site_response" do
      let(:link) { Link.new({}) }

      it "does nothing if the site data is blank" do
        link.parse_site_response

        link.title.should be_nil
        link.site_content.should be_nil
        link.host.should be_nil
      end

      it "sets the title" do
        site_response = stub(title: "Github").as_null_object
        link.stub!(site_response: site_response)

        link.parse_site_response
        link.title.should == "Github"
      end

      it "sets the actual html content" do
        content = '<tag with="attributes" that=\'have weird stuff\'>and data</tag>'
        site_response = stub(content: content).as_null_object
        link.stub!(site_response: site_response)

        link.parse_site_response
        link.site_content.should == content
      end

      it "sets the host" do
        host = 'www.example.com'
        link = Link.new(resource_attrs)
        link.host.should == host
      end
    end

    describe "is taggable" do
      it "knows that it is taggable" do
        link = Link.new
        link.should be_taggable
      end

      it "has a tagging order" do
        link = Link.new
        link.tagging_order.should == [:title, :site_content]
      end

      it "has a proposed_tags method" do
        link = Link.new
        link.should respond_to(:proposed_tags)
      end
    end
  end
end
