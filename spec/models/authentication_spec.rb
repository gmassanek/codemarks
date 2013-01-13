require 'spec_helper'

describe Authentication do
  context "requires" do
    [:provider, :uid, :nickname].each do |field|
      it "a #{field}" do
        authentication = Fabricate.build(:authentication, field.to_sym => nil)
        authentication.should_not be_valid
      end
    end
  end

  it "knows which providers are possible" do
    Authentication.providers.should include(:twitter)
    Authentication.providers.should include(:github)
  end
end
