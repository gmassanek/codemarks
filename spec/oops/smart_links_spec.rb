require 'spec_helper'
include OOPs

describe OOPs::SmartLink do
  it "requires a link" do
    lambda {
      SmartLink.new(nil)
    }.should raise_error(LinkRequiredError)
  end

  it "returns a better link" do
    link = Fabricate.build(:link)
    SmartLink.new(link).better_link.should be_kind_of(Link)
  end

  it "a valid URL" do
    link = Fabricate.build(:link, url: "/dfd.this_isNotaURL")
    lambda {
      SmartLink.new(link)
    }.should raise_error(InvalidLinkError)
  end

  it "a link object with a url" do
    link = Fabricate.build(:link, url: "http://google2342fasd.com/")
    lambda {
      SmartLink.new(link)
    }.should_not raise_error(InvalidLinkError)
  end

  context "with responsive links" do
    # TODO Make these offline tests
    let(:link) { Fabricate(:link, url: "http://www.google.com") }
    let(:smart_link) { SmartLink.new(link) }

    it "extracts the title of a page" do
      smart_link.better_link.title.should == "Google"
    end

    it "extracts the host out of a good link" do
      smart_link.better_link.host.should == "www.google.com"
    end

    it "stores the response" do
      smart_link.better_link.response.should_not be_nil
    end
  end
end
