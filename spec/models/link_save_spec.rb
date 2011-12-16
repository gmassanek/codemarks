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
  
  it "is unarchived by default" do
    LinkSave.new.should_not be_archived
  end

  it "retrieves unarchived link saves" do
    new_ls = Fabricate(:link_save, archived: false)
    old_ls = Fabricate(:link_save, archived: true)
    LinkSave.unarchived.should == [new_ls]
  end

  it "sorts by save date" do
    old_ls = Fabricate(:link_save, :created_at => 3.years.ago)
    new_ls = Fabricate(:link_save, :created_at => 3.minutes.ago)
    med_ls = Fabricate(:link_save, :created_at => 3.days.ago)
    LinkSave.by_save_date.should == [new_ls, med_ls, old_ls]
  end

  it "sorts by popularity" do
    boring = Fabricate(:link_save)
    3.times { Fabricate(:click, link: boring.link) }
    popular = Fabricate(:link_save)
    9.times { Fabricate(:click, link: popular.link) }
    pretty_good = Fabricate(:link_save)
    5.times { Fabricate(:click, link: pretty_good.link) }

    LinkSave.by_popularity.should == [popular, pretty_good, boring]
  end

  it "delegates title and url to it's link" do
    link_save = Fabricate.build(:link_save)
    link = link_save.link
    link_save.title.should == link.title
    link_save.url.should == link.url
  end

  it "has topics through codemarks (link saves)" do
    link_save = Fabricate(:link_save)
    link_save.topics.should_not be_blank
  end


  #it "is deleted if a link is deleted" do
  #  link_save = Fabricate(:link_save)
  #  link_save.link.destroy
  #  LinkSave.count.should == 0
  #end
end
