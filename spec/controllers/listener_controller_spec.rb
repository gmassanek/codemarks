require 'spec_helper'

describe ListenerController do
  describe "#prepare_bookmarklet" do
    let(:valid_url) { "http://www.example.com" }

    it "sends the url to Codemarks::Codemark.new" do
      Codemark.should_receive(:prepare).with(:link, {:url => valid_url})
      get :prepare_bookmarklet, format: :js, l: valid_url
    end

    it "assigns @user_id from the :l parameter" do
      get :prepare_bookmarklet, format: :js, l: valid_url, id: 4
      assigns[:user_id].should == "4"
    end

    it "assigns @codemark" do
      cm = mock
      Codemark.stub!(:new => cm)
      get :prepare_bookmarklet, format: :js, l: valid_url
      assigns[:codemark].should == cm
    end

    it "actually creates a codemark even without stubbing - INTEGRATION?" do
      get :prepare_bookmarklet, format: :js, l: valid_url
      assigns[:codemark].should be_a Codemark
    end

    it "passes off parsing params to a listener params parser"
    it "requires a user"
    it "what happens if codemark response isn't successful"

  end

  describe "#github" do
    it "works" do
      Fabricate(:topic, :title => "github")
      user = Fabricate(:github_user)
      user.authentications.first.update_attribute(:nickname, 'gmassanek')
      payload_from_github = %! {\"pusher\":{\"name\":\"gmassanek\",\"email\":\"gmassanek@gmail.com\"},\"repository\":{\"name\":\"codemarks\",\"size\":160,\"has_wiki\":true,\"created_at\":\"2011/11/01 04:45:37 -0700\",\"private\":false,\"watchers\":5,\"fork\":false,\"language\":\"Ruby\",\"url\":\"https://github.com/gmassanek/codemarks\",\"pushed_at\":\"2012/03/10 11:47:36 -0800\",\"has_downloads\":true,\"open_issues\":20,\"homepage\":\"\",\"has_issues\":true,\"forks\":4,\"description\":\"\",\"owner\":{\"name\":\"gmassanek\",\"email\":\"gmassanek@gmail.com\"}},\"forced\":false,\"after\":\"280f3e53332cccdde6971378d347d05f6b20f8e0\",\"head_commit\":{\"modified\":[\"app/controllers/listener_controller.rb\"],\"added\":[],\"author\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"},\"timestamp\":\"2012-03-10T11:47:31-08:00\",\"removed\":[],\"url\":\"https://github.com/gmassanek/codemarks/commit/280f3e53332cccdde6971378d347d05f6b20f8e0\",\"id\":\"280f3e53332cccdde6971378d347d05f6b20f8e0\",\"distinct\":true,\"message\":\"[ci skip] More\",\"committer\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"}},\"deleted\":false,\"commits\":[{\"modified\":[\"app/controllers/listener_controller.rb\"],\"added\":[],\"author\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"},\"timestamp\":\"2012-03-10T11:46:51-08:00\",\"removed\":[],\"url\":\"https://github.com/gmassanek/codemarks/commit/f3f7a26790ed0cb9cd7a62d05f950f705ee39889\",\"id\":\"f3f7a26790ed0cb9cd7a62d05f950f705ee39889\",\"distinct\":true,\"message\":\"more #cm\",\"committer\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"}},{\"modified\":[\"app/controllers/listener_controller.rb\"],\"added\":[],\"author\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"},\"timestamp\":\"2012-03-10T11:47:31-08:00\",\"removed\":[],\"url\":\"https://github.com/gmassanek/codemarks/commit/280f3e53332cccdde6971378d347d05f6b20f8e0\",\"id\":\"280f3e53332cccdde6971378d347d05f6b20f8e0\",\"distinct\":true,\"message\":\"[ci skip] More\",\"committer\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"}}],\"ref\":\"refs/heads/master\",\"compare\":\"https://github.com/gmassanek/codemarks/compare/7763274...280f3e5\",\"before\":\"7763274bdb41666ac8c19883cc9a48a22d2b9bd5\",\"created\":false}!
      lambda {
        post :github, :payload => payload_from_github
      }.should change(CodemarkRecord, :count).by(1)
    end
  end
end
