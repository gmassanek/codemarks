require_relative '../../../app/models/codemarks/link'

class Link; end

describe Codemarks::Link do
  let(:valid_url) { "http://www.example.com" }


  describe "is taggable" do
    it "knows that it is taggable" do
      link = Codemarks::Link.new(nil)
      link.should be_taggable
    end

    it "has a tagging order" do
      link = Codemarks::Link.new
      link.tagging_order.should == [:title, :site_content]
    end

    it "has a tag method" do
      link = Codemarks::Link.new
      link.should respond_to(:tag)
    end
  end

  describe "#commit" do
    it "creates a link record in the database" do
      Link.should_receive(:create)
      link = Codemarks::Link.new(nil)
      link.commit
    end
  end

  describe "#initialize" do
    it "sets the link's url" do
      link = Codemarks::Link.new(valid_url)
      link.url.should == valid_url
    end

    # TODO Make these offline tests - probably perfect for VCR
    # TODO analyze the stubbing here - might need wrapper class for URI
    describe "#gathers_site_response" do
      it "is non-nil for valid urls" do
        link = Codemarks::Link.new(valid_url)
        link.site_response.should_not be_nil
        link.should be_valid_url
      end

      invalid_urls = ["twitter.com", "twitter", "www.twitter.com"]
      invalid_urls.each do |url|
        it "is nil for invalid urls like #{url}" do
          link = Codemarks::Link.new(url)
          link.site_response.should be_nil
          link.should_not be_valid_url
        end
      end
    end

    describe "#parse_site_response" do
      let(:link) { Codemarks::Link.new("") }

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
        link = Codemarks::Link.new(valid_url)
        link.host.should == host
      end
    end
  end
end

#it "gets all links for a list of codemarks" do
#  codemark1 = Fabricate(:codemark)
#  codemark2 = Fabricate(:codemark)
#  Link.for([codemark1, codemark2]).should == [codemark1.link, codemark2.link]
#end
#
#    describe "topics" do
#      it "are associated through codemarks" do
#        github = Fabricate(:topic, title: "Github")
#        codemark = Fabricate(:codemark, topics: [github])
#        codemark.link.topics.should == [github]
#      end
#    end
#  end
#end
