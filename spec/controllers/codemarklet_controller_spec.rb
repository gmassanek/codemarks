require 'spec_helper'

describe CodemarkletController do
  describe "#new" do
    it "is successful" do
      CodemarkletController.any_instance.stub(:'logged_in?' => true)
      get :new, :url => 'http://www.google.com'
      response.should be_success
    end
  end
end
