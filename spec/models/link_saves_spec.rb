require 'spec_helper'

describe LinkSave do
  it "can fabricate one" do
    link_save = Fabricate(:link_save)
  end

  it "requires a link" do
    link_save = Fabricate.build(:link_save)
    link_save.link = nil
    link_save.should_not be_valid
  end
end
