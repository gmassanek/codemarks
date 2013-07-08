require 'spec_helper'

describe CodemarksController do
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

  describe "new" do
    let(:valid_url) { "http://www.example.com" }

    it "finds codemarks by id" do
      cm = Fabricate(:codemark_record)
      get :new, :format  => :json, :id => cm.id
      assigns(:codemark).should == cm
    end

    it "finds codemarks by url" do
      user = Fabricate(:user)
      controller.stub(:current_user_id => user.id)

      cm = Fabricate(:codemark_record, :user => user)
      get :new, :format  => :json, :url => cm.resource.url
      assigns(:codemark).should == cm
    end

    it "creates a new codemark for that resource" do
      link = Fabricate(:link_record)
      get :new, :format  => :json, :url => link.url
      assigns(:codemark).resource.should == link
    end
  end

  describe "#create" do
    before do
      @user = Fabricate(:user)
      controller.stub(:current_user_id => @user.id)
      @resource = Fabricate(:link_record)
      @link = Fabricate(:link_record)
      @topics = [Fabricate(:topic), Fabricate(:topic)]

      @params = { "codemark"=> {
        "title"=>"jQuery Knob demo",
        "description"=>"",
        "resource_id" => @link.id,
        "resource_type" => 'LinkRecord',
        "topic_ids"=>"#{@topics.first.slug},test-new-topic"
      }
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
  end
end
