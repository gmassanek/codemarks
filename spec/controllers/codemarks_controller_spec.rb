require 'spec_helper'

describe CodemarksController do
  describe "build_linkmark" do
    let(:valid_url) { "http://www.example.com" }

    it "sends the url to Codemarks::Codemark.new" do
      Codemarks::Codemark.should_receive(:new).with(valid_url)
      get :build_linkmark, format: :js, url: valid_url
    end

    it "creates a new codemark with the new link" do
      get :build_linkmark, format: "js", url: valid_url
      assigns(:codemark).link.url.should == valid_url
    end

    it "link has an invalid_url if it is a nonsense url" do
      get :build_linkmark, format: "js", url: "http://thisshouldntblowup"
      assigns(:codemark).link.should_not be_valid_url
    end

    it "link has an invalid_url if no url is provided" do
      get :build_linkmark, format: "js", url: nil
      assigns(:codemark).link.should_not be_valid_url
    end
  end
end

#    it "creates a new codemark" do
#      send @method, @action, @params
#      assigns(:new_codemark).should be_kind_of(Codemark)
#    end
#
#    context "new url" do
#      it "makes a new link" do
#        send @method, @action, @params
#        controller.params.should include(:action)
#        controller.params.should include(:url)
#        assigns(:new_codemark).link.should be_kind_of(Link)
#        assigns(:new_codemark).link.should be_new_record
#        assigns(:new_codemark).link.url.should == "http://www.google.com"
#      end
#
#      it "makes the link a smart link" do
#        send @method, @action, @params
#        assigns(:new_codemark).link.title.should == "Google"
#      end
#    end
#
#    it "finds matches a link if one exists already" do
#      link = Fabricate(:link, url: "http://www.google.com")
#      send @method, @action, @params
#      assigns(:new_codemark).link.should == link
#    end
#
#    it "fetches the topics based on the link" do
#      google = Fabricate(:topic, title: "google")
#      link = Fabricate.build(:link, url: "http://www.google.com")
#      send @method, @action, @params
#      assigns(:new_codemark).topics.should include(google)
#    end
#  end
#  context "#edit" do
#    it "works" do
#      codemark = Fabricate(:codemark)
#      get :edit, id: codemark.id
#      response.should be_successful
#    end
#  end
#end
