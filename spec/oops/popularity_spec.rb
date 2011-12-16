require 'spec_helper'

describe OOPs::LinkPopularity do
  describe "#calculate" do
    it "has a popularity of 0 if the link is nil" do
      OOPs::LinkPopularity.calculate(nil).should == 0
    end
    it "increases with a link click" do
      link = Fabricate(:link, :clicks_count => 4)
      Fabricate(:click, link: link)
      OOPs::LinkPopularity.calculate(Link.last).should == 5
    end
    it "increases with a link save" do
      link = Fabricate(:link, codemarks_count: 4)
      Fabricate(:codemark, link: link)
      OOPs::LinkPopularity.calculate(Link.last).should == 5
    end
  end
end
