require 'spec_helper'

describe Click do
  it "requires a link" do
    click = Fabricate.build(:click, link: nil)
    click.should_not be_valid
  end

  it "increments the click_count when it's saved" do
    link = Fabricate(:link, :clicks_count => 5)
    click = Fabricate(:click, link: link)
    Link.find(link.id).clicks_count.should == 6
  end

end
