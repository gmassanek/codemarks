require 'spec_helper'

describe FindCodemarks do
  before do
    @user = Fabricate(:user)
    @cm = Fabricate(:codemark_record, :user => @user)
    @cm2 = Fabricate(:codemark_record, :user => @user)
  end

  context "general result rules" do
    it "doesn't return multiple cms for the same link" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      all_cms = FindCodemarks.new
      all_cms.codemarks.all.count.should == 2
    end

    it "returns my cm even if other people saved the same link" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      all_cms = FindCodemarks.new(:user => @user)
      all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
    end

    it "returns the save count" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      all_cms = FindCodemarks.new
      all_cms.codemarks.first.save_count.should == 2
    end
  end

  context "for a user" do
    let(:find_by_user) { FindCodemarks.new(:user => @user) }

    it "gets all the Codemarks" do
      find_by_user.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
    end

    it "returns an ActiveRecord::Relation" do
      find_by_user.codemarks.should be_a ActiveRecord::Relation
    end
  end

  context "public" do
    it "should find all codemarks regardless of user" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user)
      all_cms = FindCodemarks.new
      all_cms.codemarks.should =~ [@cm, @cm2, @cm3]
    end
  end

  context "sort orders" do
    it "defaults to ordering by most recently created" do
      @cm.update_attribute(:created_at, 9.days.ago)
      @cm2.update_attribute(:created_at, 3.days.ago)
      @cm3 = Fabricate(:codemark_record, :created_at => 5.days.ago)
      all_cms = FindCodemarks.new
      all_cms.codemarks.collect(&:id).should == [@cm2.id, @cm3.id, @cm.id]
    end

    it "can be sorted by save_count" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      @cm4= Fabricate(:codemark_record, :user => @user)
      all_cms = FindCodemarks.new(:sort_by => :save_count)
      all_cms.codemarks.first.save_count.should == 2
    end
  end

  context "with paging" do
    it "can take the result from a query and page it" do
      find_by_user_paged = FindCodemarks.new(:user => @user, :page => 1, :per_page => 1)
      find_by_user_paged.codemarks.all.count.should == 1
    end
    
    it "defaults to 10 per page" do
      15.times do
        Fabricate(:codemark_record)
      end
      all_cms = FindCodemarks.new
      all_cms.codemarks.all.count.should == 10
    end
  end
end
