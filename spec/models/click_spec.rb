require 'spec_helper'

describe Click do
  it "requires a link" do
    click = Fabricate.build(:click, link_record: nil)
    click.should_not be_valid
  end

  it "increments the click_count when it's saved" do
    link_record = Fabricate(:link_record, :clicks_count => 5)
    click = Fabricate(:click, link_record: link_record)
    LinkRecord.find(link_record.id).clicks_count.should == 6
  end

end
