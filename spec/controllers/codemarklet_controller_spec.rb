require 'spec_helper'

describe CodemarkletController do
  describe "#new" do
    it "is successful", :vcr => { cassette_name: 'codemarks' } do
      CodemarkletController.any_instance.stub(:'logged_in?' => true)
      user = Fabricate(:user)
      controller.stub(:current_user => user)
      get :new, :url => 'http://www.google.com'
      response.should be_success
    end
  end
end
