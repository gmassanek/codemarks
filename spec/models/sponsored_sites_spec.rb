require 'spec_helper'

describe SponsoredSite do

  [:site, :url, :topic].each do |field|
    it "requires a #{field}" do
      site = Fabricate.build(:sponsored_site)
      site.update_attribute(field,nil)
      site.should_not be_valid
    end
  end

  it "requires one of the predeifined site types" do
    site = Fabricate.build(:sponsored_site)
    site.site = 'some_other_thing'
    site.should_not be_valid
  end

end
