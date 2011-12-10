require 'spec_helper'

describe Authentication do
  context "requires" do
    [:provider, :uid, :user].each do |field|
      it "a #{field}" do
        authentication = Fabricate.build(:authentication, field.to_sym => nil)
        authentication.should_not be_valid
      end
    end
  end
end
