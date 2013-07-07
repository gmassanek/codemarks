require 'spec_helper'

describe TextRecord do
  it "requires text" do
    text = TextRecord.new(:text => nil)
    text.should_not be_valid
  end
end
