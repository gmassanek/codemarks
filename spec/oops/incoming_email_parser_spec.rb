require 'spec_helper'
require 'incoming_email_parser'

describe IncomingEmailParser do
  let(:params) { {:from => "<Test User> test@example.com" } }

  it "searches users by email" do
    User.should_receive(:find_by_email).with("test@example.com")
    IncomingEmailParser.parse params
  end

  it "extracts emails from a string" do
    IncomingEmailParser.extract_email(params[:from]).should == "test@example.com"
    IncomingEmailParser.extract_email("hey there test@example.com").should == "test@example.com"
    IncomingEmailParser.extract_email("there test@example.com it works").should == "test@example.com"
  end

  it "stores a link if the user exists" do
    Fabricate(:user, email: "test@example.com")
    google = Fabricate(:topic, title: "google")
    params[:text] = "http://www.google.com /n My Signature"
    Tagger.should_receive(:get_tags_for_link).and_return([google])
    lambda {
      IncomingEmailParser.parse(params)
    }.should change(Codemark, :count).by(1)
  end

  context "pulls out urls" do
    it "for a perfect link" do
      body = "http://www.google.com /n My Signature"
      IncomingEmailParser.extract_urls_into_array(body).length.should == 1
      IncomingEmailParser.extract_urls_into_array(body).first.should == "http://www.google.com"
    end

    it "for multiple links" do
      body = "here is a link to http://www.google.com and http://www.yahoo.com"
      IncomingEmailParser.extract_urls_into_array(body).should == ["http://www.google.com", "http://www.yahoo.com"]
    end
  end
end
