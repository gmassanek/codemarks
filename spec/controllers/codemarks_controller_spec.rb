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
      codemarks = {}
      PresentCodemarks.stub!(:for => codemarks)
      get :index, :format => :json
      assigns[:codemarks].should == codemarks
    end

    it 'fills html' do
      codemarks = {}
      PresentCodemarks.stub!(:for => codemarks)
      get :index, :format => :html
      response.body.should include 'codemarks_json'
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
end
