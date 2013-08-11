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

  describe "#new" do
    let(:valid_url) { "http://www.example.com" }

    it "finds codemarks by id" do
      cm = Fabricate(:codemark_record)
      get :new, :format  => :json, :id => cm.id
      JSON.parse(response.body)['id'].should == cm.id
    end

    it "finds codemarks by url" do
      user = Fabricate(:user)
      controller.stub(:current_user_id => user.id)

      cm = Fabricate(:codemark_record, :user => user)
      get :new, :format  => :json, :url => cm.resource.url
      JSON.parse(response.body)['id'].should == cm.id
    end

    it "creates a new codemark for that resource" do
      link = Fabricate(:link_record)
      get :new, :format  => :json, :url => link.url
      JSON.parse(response.body)['resource_id'].should == link.id
    end

    it "fills new codemarks with suggested tags" do
      github = Topic.create!(:title => 'github')
      link = Fabricate(:link_record, :title => 'Github')
      get :new, :format  => :json, :url => link.url
      JSON.parse(response.body)['topics'].first['title'].should == 'github'
    end
  end

  describe "#create" do
    before do
      @user = Fabricate(:user)
      controller.stub(:current_user_id => @user.id)
      @resource = Fabricate(:link_record)
      @link = Fabricate(:link_record)
      @topics = [Fabricate(:topic), Fabricate(:topic)]

      @params = {
        "format" => :json,
        "codemark"=> {
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
        post :create, @params
      }.to change(CodemarkRecord, :count).by 1
    end

    it 'creates a text codemark' do
      @params["codemark"]["resource_type"] = 'TextRecord'
      @params["codemark"]["resource_id"] = nil
      @params["resource"] = {'text' => 'Sample text codemark'}

      expect {
        post :create, @params
      }.to change(CodemarkRecord, :count).by 1
      CodemarkRecord.last.resource.should be_a TextRecord
    end

    it 'creates topics' do
      expect {
        post :create, @params
      }.to change(Topic, :count).by 1
    end
  end
end
