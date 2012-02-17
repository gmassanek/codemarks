require 'fast_helper'

class LinkRecord; end

describe Link do
  let(:valid_url) { "http://www.example.com" }
  let(:resource_attrs) { { url: valid_url } }

  describe "#create" do
    it "creates a link record in the database" do
      LinkRecord.should_receive(:create)
      Link.create({})
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
