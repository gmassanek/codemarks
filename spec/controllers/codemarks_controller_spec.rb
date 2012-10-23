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
      PresentCodemarks.stub(:present)
      get :new, :format  => :json, :url => valid_url
    end

    it "creates a new codemark with the new link" do
      codemark = stub
      Codemark.stub(:load) { codemark }
      PresentCodemarks.stub(:present)

      get :new, :format => :json
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
                                "description"=>"",
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
        post :create, @params.merge(:format => :json)
      }.to change(CodemarkRecord, :count).by 1
    end

    it 'creates a topic' do
      expect {
        post :create, @params.merge(:format => :json)
      }.to change(Topic, :count).by 1
    end

    it 
  end
end
