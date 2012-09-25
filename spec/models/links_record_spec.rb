require 'spec_helper'

describe LinkRecord do
  let(:valid_url) { "http://www.example.com" }

  required_attributes = [:url, :host]
  required_attributes.each do |attr|
    it "requires a #{attr}" do
      link = Fabricate.build(:link_record, attr => nil)
      link.should_not be_valid
    end
  end

  it 'coerces title to an empty string' do
    link = LinkRecord.create(:url => 'http://www.google.com', :host => 'google.com')
    link.title.should == ''
  end
end
