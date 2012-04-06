require 'spec_helper'

describe CodemarkletController do
  describe "#new" do
    it "is successful" do
      get :new
      response.should be_success
    end
  end
end
