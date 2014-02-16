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
      Fabricate(:codemark)
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
      cm = Fabricate(:codemark)
      get :new, :format => :json, :id => cm.id
      JSON.parse(response.body)['id'].should == cm.id
    end

    it "finds a user's codemarks by url" do
      user = Fabricate(:user)
      controller.stub(:current_user_id => user.id)

      cm = Fabricate(:codemark, :user => user)
      get :new, :format => :json, :url => cm.resource.url
      JSON.parse(response.body)['id'].should == cm.id
    end

    it "creates a new codemark for that resource" do
      link = Fabricate(:link)
      get :new, :format => :json, :url => link.url
      JSON.parse(response.body)['resource_id'].should == link.id
    end

    it "fills new codemarks with suggested tags" do
      github = Topic.create!(:title => 'github')
      link = Fabricate(:link, :title => 'Github')
      get :new, :format => :json, :url => link.url
      JSON.parse(response.body)['topics'].first['title'].should == 'github'
    end
  end

  describe "#create" do
    before do
      @user = Fabricate(:user)
      controller.stub(:current_user_id => @user.id)
      @resource = Fabricate(:link)
      @link = Fabricate(:link)
      @topics = [Fabricate(:topic), Fabricate(:topic)]

      @params = {
        "format" => :json,
        "codemark"=> {
          "title"=>"jQuery Knob demo",
          "description"=>"",
          "resource_id" => @link.id,
          "resource_type" => 'Link',
          "topic_ids"=>"#{@topics.first.slug},test-new-topic"
        }
      }
    end

    it 'creates a codemark' do
      expect {
        post :create, @params
      }.to change(Codemark, :count).by 1
    end

    it 'creates a text codemark' do
      @params["codemark"]["resource_type"] = 'Text'
      @params["codemark"]["resource_id"] = nil
      @params["resource"] = {'text' => 'Sample text codemark'}

      expect {
        post :create, @params
      }.to change(Codemark, :count).by 1
      Codemark.last.resource.should be_a Text
    end

    it 'creates topics' do
      expect {
        post :create, @params
      }.to change(Topic, :count).by 1
    end

    it 'creates codemarks in a group' do
      group = Group.create!(:name => 'group1')
      @params['codemark']['group_id'] = group.id
      post :create, @params
      Codemark.last.group.should == group
      Topic.last.group.should == group
    end

    describe 'source' do
      it 'uses the incoming source' do
        @params['codemark']['source'] = 'web'
        post :create, @params
        Codemark.last.source.should == 'web'
      end
    end
  end

  describe '#sendgrid' do
    before do
      Fabricate(:link, :url => 'http://www.google.com/')
      @user = Fabricate(:user, :email => 'test@example.com')
      @body = eval(File.open('fixtures/sendgrid_email_post.txt').read)
      @body['from'] = 'test <test@example.com>'
    end

    it 'does nothing for unknown senders' do
      @body['from'] = 'somebody <someone-random@test.com>'
      expect {
        post :sendgrid, @body
      }.to change(Codemark, :count).by(0)
      response.code.should == '200'
    end

    it 'saves the first link from the body to the senders account' do
      @body['text'] = 'This link was awesome! Save it. http://www.google.com'
      expect {
        post :sendgrid, @body
      }.to change(Codemark, :count).by(1)
      Codemark.last.user.should == @user
      Codemark.last.resource.url.should == 'http://www.google.com/'
      response.code.should == '200'
    end

    it 'does nothing if there are no links in the body' do
      @body['text'] = 'This link was awesome! But I forgot to put it in!'
      expect {
        post :sendgrid, @body
      }.to change(Codemark, :count).by(0)
      response.code.should == '200'
    end

    it 'only saves one link' do
      @body['text'] = 'This link was awesome! Save it. http://www.google.com \n\r http://www.mywebsite.com'
      expect {
        post :sendgrid, @body
      }.to change(Codemark, :count).by(1)
      Codemark.last.resource.url.should == 'http://www.google.com/'
      response.code.should == '200'
    end

    it 'uses everthing before the first new line as a the description' do
      @body['text'] = "Here is a link http://www.google.com And some more stuff\n\nGeoff\nSignature"
      post :sendgrid, @body
      Codemark.last.description.should == 'Here is a link And some more stuff'
    end
  end

  describe '#show' do
    let(:user) { Fabricate(:user) }
    let(:codemark) { Fabricate(:codemark, :user => user) }

    it 'renders a codemark successfully' do
      controller.stub(:current_user_id => user.id)
      get :show, :id => codemark.id
      response.should be_success
    end

    describe 'authorization by group' do
      it 'is successful when authorized' do
        get :show, :id => codemark.id
        response.should be_success
      end

      it 'redirects unauthorized web requests' do
        UserCodemarkAuthorizer.any_instance.stub(:authorized? => false)
        get :show, :id => codemark.id
        response.should be_redirect
      end

      it '401s unauthorized json requests' do
        UserCodemarkAuthorizer.any_instance.stub(:authorized? => false)
        get :show, :id => codemark.id, :format => :json
        response.code.should == '401'
      end
    end
  end
end
