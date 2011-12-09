require 'spec_helper'

describe LinkSave do
  context "requires" do
    [:link, :user].each do |field|
      it "a #{field}" do
        link_save = Fabricate.build(:link_save, field => nil)
        link_save.should_not be_valid
      end
    end
  end
  
  #it "is deleted if a link is deleted" do
  #  link_save = Fabricate(:link_save)
  #  link_save.link.destroy
  #  LinkSave.count.should == 0
  #end
end
