require 'spec_helper'

describe Click do
  it "requires a link" do
    click = Fabricate.build(:click, resource: nil)
    click.should_not be_valid
  end

  it "increments the click_count when it's saved" do
    link_record = Fabricate(:link_record, :clicks_count => 5)
    click = Fabricate(:click, resource: link_record)
    LinkRecord.find(link_record.id).clicks_count.should == 6
  end
end
