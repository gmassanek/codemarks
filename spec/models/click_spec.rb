require 'spec_helper'

describe Click do

  it "requires a link" do
    click = Fabricate(:click)
    click.link = nil
    click.should_not be_valid
  end


end
