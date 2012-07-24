require 'spec_helper'

describe CodemarksController do

  ##=======     Receiver    =======###
  describe "#index" do
    it "calls FindCodemarks" do
      codemarks = []
      codemarks.stub(:num_pages)
      finder = stub(:codemarks => codemarks)
      FindCodemarks.should_receive(:new).and_return(finder)
      get :index, :format => :json
    end

    it "it assigns codemarks" do
      Fabricate(:codemark_record)
      get :index, :format => :json
      assigns[:codemarks].should_not be_nil
    end

    it "it presents codemarks" do
      codemarks = []
      PresentCodemarks.stub!(:for => codemarks)
      get :index, :format => :json
      assigns[:codemarks].should == codemarks
    end
  end
  ##=======     Receiver    =======###


  describe "new" do
    let(:valid_url) { "http://www.example.com" }

    it "asks for a prepared codemark" do
      Codemark.should_receive(:load).with(:url => valid_url)
      get :new, :format  => :js, :url => valid_url
    end

    it "creates a new codemark with the new link" do
      codemark = stub
      Codemark.stub(:load) { codemark }

      get :new, format: "js"
      assigns(:codemark).should == codemark
    end
  end

  describe "#create" do
    it 'does not break with perfect input' do
      @resource = Fabricate(:link_record)
      @attributes = {
        :resource_id => @resource.id
      }
      @params = {
        :codemark => @attributes
      }
      topics = [Fabricate(:topic), Fabricate(:topic)]
      @topic_info = { }
      topics.each { |t| @topic_info[t.id] = [t.id] }
      user = stub(:id => 11)
      controller.stub!(:current_user_id => user.id)

      @topic_ids = { 'woo' => 'woo'}
      post :create, :format => :js, :codemark => @attributes, :topic_info => @topic_info, :topic_ids => @topic_ids
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
