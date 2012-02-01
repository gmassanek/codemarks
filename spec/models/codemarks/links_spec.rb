require_relative '../../../app/models/codemarks/link'

describe Codemarks::Link do
  let(:valid_url) { "http://www.example.com" }

  describe "#commit" do
    #it "passes off persistence to AR and returns it" do
    #  ar_link = mock(:link)
    #  ::Link.should_receive(:create).and_return(ar_link)
    #  link = Codemarks::Link.new(valid_url)
    #  link.commit
    #  link.link_record.should == ar_link
    #end
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
