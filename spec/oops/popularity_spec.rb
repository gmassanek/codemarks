require 'spec_helper'

describe OOPs::LinkPopularity do
  describe "#calculate" do
    it "increases with a link click" do
      link = Fabricate(:link, :clicks_count => 4)
      Fabricate(:click, link: link)
      OOPs::LinkPopularity.calculate(Link.last).should == 5
    end
    it "increases with a link save" do
      link = Fabricate(:link, link_saves_count: 4)
      Fabricate(:link_save, link: link)
      OOPs::LinkPopularity.calculate(Link.last).should == 5
    end
  end
end
