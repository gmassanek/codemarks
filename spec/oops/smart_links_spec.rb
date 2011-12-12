require 'spec_helper'
include OOPs

describe OOPs::SmartLink do
  it "requires a URL" do
    lambda {
      SmartLink.new("")
    }.should raise_error(ValidURLRequiredError)
  end

  it "requires a valid URL" do
    lambda {
      SmartLink.new("htp://nothanks")
    }.should raise_error(ValidURLRequiredError)
  end

  it "extracts the title of a page" do
    # TODO Make this an offline test
    smart_link = SmartLink.new("http://www.google.com")
    smart_link.title.should == "Google"
  end

  it "finds the topics for a smartlink" do
    smart_link = SmartLink.new("http://www.google.com")
    google = Fabricate(:topic, title: "Google")
    smart_link.topics.should include(google)
  end

end
