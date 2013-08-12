require 'spec_helper'

describe Text do
  it "requires text" do
    text = Text.new(:text => nil)
    text.should_not be_valid
  end
end
