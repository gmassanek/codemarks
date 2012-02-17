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
end
