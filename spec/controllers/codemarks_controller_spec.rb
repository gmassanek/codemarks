require 'spec_helper'

describe CodemarksController do
  describe "build_link" do
    before do
      @method = :get
      @action = :build_link
      @params = {format: "js", :url => "http://www.google.com"}
    end

    it "creates a new codemark" do
      send @method, @action, @params
      assigns(:codemark).should be_kind_of(Codemark)
    end

    context "new url" do
      it "makes a new link" do
        send @method, @action, @params
        controller.params.should include(:action)
        controller.params.should include(:url)
        assigns(:codemark).link.should be_kind_of(Link)
        assigns(:codemark).link.should be_new_record
        assigns(:codemark).link.url.should == "http://www.google.com"
      end

      it "makes the link a smart link" do
        send @method, @action, @params
        assigns(:codemark).link.title.should == "Google"
      end
    end

    it "finds matches a link if one exists already" do
      link = Fabricate(:link, url: "http://www.google.com")
      send @method, @action, @params
      assigns(:codemark).link.should == link
    end

    it "fetches the topics based on the link" do
      google = Fabricate(:topic, title: "google")
      link = Fabricate.build(:link, url: "http://www.google.com")
      send @method, @action, @params
      assigns(:codemark).topics.should include(google)
    end

  end
end
