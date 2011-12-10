require 'spec_helper'

describe OOPs::LinkPopularity do
  describe "#calculate" do
    it "increases with a link click" do
      link = Fabricate(:link)
      link.stub!(:clicks_count).and_return(4)
      Fabricate(:click, link: link)
      OOPs::LinkPopularity.calculate(link).should == 5
    end
    it "increases with a link save" do
      link = Fabricate(:link)
      link.stub!(:link_saves_count).and_return(4)
      Fabricate(:link_save, link: link)
      OOPs::LinkPopularity.calculate(link).should == 5
    end
  end
end
