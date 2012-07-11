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
      all_cms.codemarks.first.save_count.should == "2"
    end

    it "returns the save count when scoped by user" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      all_cms = FindCodemarks.new(:user => user)
      all_cms.codemarks.first.save_count.should == "2"
    end

    it "returns the resource author" do
      @cm.link_record.update_attributes(:author => @user)

      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      codemarks  = FindCodemarks.new.codemarks
      codemarks.first.resource_author.should == @user
    end

    it "returns the visit count" do
      user = Fabricate(:user)
      all_cms = FindCodemarks.new
      all_cms.codemarks.first.visit_count.should == "0"
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

    it 'does include my private codemarks' do
      private_codemark = Fabricate(:codemark_record, :private => true, :user => @user)
      all_cms = FindCodemarks.new(:user => @user, :current_user => @user)
      all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id, private_codemark.id]
    end

    it 'does not include other people\'s private codemarks' do
      user = Fabricate(:user)
      private_codemark = Fabricate(:codemark_record, :private => true, :user => user)
      all_cms = FindCodemarks.new(:user => @user, :current_user => user)
      all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
    end
  end

  context "for a topic" do
    let(:topic) { @cm.topics.first }
    let(:find_by_topic) { FindCodemarks.new(:topic => topic) }

    it "gets all the Codemarks" do
      cm3 = Fabricate(:codemark_record, :topic_ids => [topic.id])
      find_by_topic.codemarks.collect(&:id).should =~ [@cm.id, cm3.id]
    end
  end

  context "public" do
    it "should find all codemarks regardless of user" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user)
      all_cms = FindCodemarks.new
      all_cms.codemarks.should =~ [@cm, @cm2, @cm3]
    end

    it 'does not include other users private codemarks' do
      user = Fabricate(:user)
      private_codemark = Fabricate(:codemark_record, :private => true, :user => user)
      all_cms = FindCodemarks.new(:current_user => @user)
      all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
    end
  end

  context "ordering" do
    it "defaults to ordering by most recently created" do
      @cm.update_attribute(:created_at, 9.days.ago)
      @cm2.update_attribute(:created_at, 3.days.ago)
      @cm3 = Fabricate(:codemark_record, :created_at => 5.days.ago)
      all_cms = FindCodemarks.new
      all_cms.codemarks.collect(&:id).should == [@cm2.id, @cm3.id, @cm.id]
    end

    it "can be orderd by save_count" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark_record, :user => user, :link_record => @cm.link_record)
      @cm4= Fabricate(:codemark_record, :user => @user)
      all_cms = FindCodemarks.new(:by => :count)
      all_cms.codemarks.first.save_count.should == "2"
    end

    it "can be orderd by visit_count" do
      user = Fabricate(:user)
      2.times { Fabricate(:click, :user => user, :link_record => @cm.link_record) }
      all_cms = FindCodemarks.new(:by => :visits)
      all_cms.codemarks.first.visit_count.should == "2"
    end
  end

  context "with paging" do
    it "can take the result from a query and page it" do
      find_by_user_paged = FindCodemarks.new(:user => @user, :page => 1, :per_page => 1)
      find_by_user_paged.codemarks.all.count.should == 1
    end
    
    it "defaults to 15 per page" do
      15.times do
        Fabricate(:codemark_record)
      end
      all_cms = FindCodemarks.new
      all_cms.codemarks.all.count.should == 15
    end
  end

  context 'with query' do
    it 'searches a codemarks title', :travis_skip => true do
      cm = Fabricate(:codemark_record, :user => @user, :title => 'My pretty pony')
      FindCodemarks.new(:search_term => 'pony').codemarks.collect(&:id).should =~ [cm.id]
    end
  end
end
