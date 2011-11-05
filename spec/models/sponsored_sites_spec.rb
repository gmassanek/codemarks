require 'spec_helper'

describe SponsoredSite do

  let(:site) {Fabricate.build(:sponsored_site)} 

  [:site, :url, :topic].each do |field|
    it "requires a #{field}" do
      site.update_attribute(field,nil)
      site.should_not be_valid
    end
  end

  it "requires one of the predeifined site types" do
    site.site = 'some_other_thing'
    site.should_not be_valid
  end

  it "requires a url that matches the site type" do
    site.site = SponsoredSite::SponsoredSites::TWITTER
    site.url = "http://www.google.com"
    site.should_not be_valid
  end

  describe "URLs" do

    ["http://www.twitter.com", "https://twitter"].each do |url|
      it "accepts #{url}" do
        site.url = url
        site.should be_valid
      end
    end

    ["twitter.com", "twitter", "www.twitter.com"].each do |url|
      it "rejects #{url}" do
        site.url = url
        site.should_not be_valid
      end
    end

  end

end
