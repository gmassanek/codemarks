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
    before do
      @user = Fabricate(:user)
      controller.stub(:current_user_id => @user.id)
      @resource = Fabricate(:link_record)
      @link = Fabricate(:link_record)
      @topics = [Fabricate(:topic), Fabricate(:topic)]

      @params = { "codemark"=> {"title"=>"jQuery Knob demo",
                                "note"=>"",
                                "resource_id" => @link.id,
                                "resource_type" => 'LinkRecord'},
                                "user_id" => @user.id,
                                "commit"=>"Add Link",
                                "topic_ids"=>{"#{@topics.first.id}"=>"#{@topics.first.id}"},
                                "new_topics"=>{"A New Topic"=>"A New Topic"}
      }
    end

    it 'creates a codemark' do
      expect {
        post :create, @params.merge(:format => :js)
      }.to change(CodemarkRecord, :count).by 1
    end

    it 'creates a topic' do
      expect {
        post :create, @params.merge(:format => :js)
      }.to change(Topic, :count).by 1
    end

    it 
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
