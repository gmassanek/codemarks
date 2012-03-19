require 'spec_helper'

describe LinkRecord do
  let(:valid_url) { "http://www.example.com" }

  required_attributes = [:url, :host, :title]
  required_attributes.each do |attr|
    it "requires a #{attr}" do
      link = Fabricate.build(:link_record, attr => nil)
      link.should_not be_valid
    end
  end
end
