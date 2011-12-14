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
      SmartLink.new("/dfd.this_isNotaURL")
    }.should raise_error(ValidURLRequiredError)
  end

  it "a link object with a url" do
    lambda {
      SmartLink.new("http://google2342fasd.com/")
    }.should_not raise_error(ValidURLRequiredError)
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

  it "extracts the host out of a good link" do
    smart_link = SmartLink.new("http://www.google.com")
    smart_link.host.should == "www.google.com"
  end

end
