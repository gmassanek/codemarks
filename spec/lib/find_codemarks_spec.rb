require 'spec_helper'

describe FindCodemarks do
  context 'there are codemarks' do
    before do
      @user = Fabricate(:user)
      @cm = Fabricate(:codemark_record, :user => @user, :topics => [Fabricate(:topic), Fabricate(:topic)])
      @cm2 = Fabricate(:codemark_record, :user => @user)
    end

    context "general result rules" do
      it "doesn't return multiple cms for the same link" do
        user = Fabricate(:user)
        @cm3 = Fabricate(:codemark_record, :user => user, :resource => @cm.resource)
        all_cms = FindCodemarks.new
        all_cms.codemarks.all.count.should == 2
      end

      it "returns my cm even if other people saved the same link" do
        user = Fabricate(:user)
        @cm3 = Fabricate(:codemark_record, :user => user, :resource => @cm.resource)
        all_cms = FindCodemarks.new(:user => @user)
        all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
      end

      it "returns the save count" do
        user = Fabricate(:user)
        @cm3 = Fabricate(:codemark_record, :user => user, :resource => @cm.resource)
        all_cms = FindCodemarks.new
        all_cms.codemarks.first.save_count.should == "2"
      end

      it "returns the save count when scoped by user" do
        user = Fabricate(:user)
        @cm3 = Fabricate(:codemark_record, :user => user, :resource => @cm.resource)
        all_cms = FindCodemarks.new(:user => user)
        all_cms.codemarks.first.save_count.should == "2"
      end

      it "returns the resource author" do
        @cm.resource.update_attributes(:author => @user)

        user = Fabricate(:user)
        @cm3 = Fabricate(:codemark_record, :user => user, :resource => @cm.resource)
        codemarks  = FindCodemarks.new.codemarks
        codemarks.first.resource_author.should == @user
      end

      it 'only shows codemarks tagged "codemarks" to gmassanek and GravelGallery' do
        gmassanek = Fabricate(:user, :nickname => 'gmassanek')
        gravelGallery = Fabricate(:user, :nickname => 'GravelGallery')
        codemarks_topic = Fabricate(:topic, :title => 'codemarks')
        cm = Fabricate(:codemark_record, :topics => [codemarks_topic])

        FindCodemarks.new.codemarks.should_not include cm
        FindCodemarks.new(:current_user => @user).codemarks.should_not include cm
        FindCodemarks.new(:current_user => gmassanek).codemarks.should include cm
        FindCodemarks.new(:current_user => gravelGallery).codemarks.should include cm
      end

      it 'shows old codemarks that I have marked with codemarks, just with other others' do
        cm = Fabricate(:codemark_record)
        gmassanek = Fabricate(:user, :nickname => 'gmassanek')
        codemarks_topic = Fabricate(:topic, :title => 'codemarks')
        cm2 = Fabricate(:codemark_record, :resource => cm.resource, :user => gmassanek, :topics => [codemarks_topic])
        FindCodemarks.new.codemarks.should include cm
      end

      it 'works if there are no codemarks tagged codemarks' do
        codemarks_topic = Fabricate(:topic, :title => 'codemarks')
        cm = Fabricate(:codemark_record)
        FindCodemarks.new.codemarks.should include cm
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

    it 'does not include other users private codemarks' do
      user = Fabricate(:user)
      private_codemark = Fabricate(:codemark_record, :private => true, :user => user)
      all_cms = FindCodemarks.new(:current_user => @user)
      all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
    end

    context "for a topic" do
      let(:topic1_id) { @cm.topics.first.id }
      let(:topic2_id) { @cm.topics.last.id }

      it "gets all the Codemarks" do
        cm3 = Fabricate(:codemark_record, :topic_ids => [topic1_id])
        cms = FindCodemarks.new(:topic_ids => [topic1_id]).codemarks
        cms.collect(&:id).should =~ [@cm.id, cm3.id]
      end

      describe 'with multiple topics' do
        it 'does not find a codemark that only matches one of the topics' do
          cm3 = Fabricate(:codemark_record, :topic_ids => [topic1_id])
          cms = FindCodemarks.new(:topic_ids => [topic1_id, topic2_id]).codemarks
          cms.should == [@cm]
        end
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
        @cm3 = Fabricate(:codemark_record, :user => user, :resource => @cm.resource)
        @cm4= Fabricate(:codemark_record, :user => @user)
        all_cms = FindCodemarks.new(:by => :count)
        all_cms.codemarks.first.save_count.should == "2"
      end

      it "can be orderd by visit_count" do
        user = Fabricate(:user)
        2.times { Fabricate(:click, :user => user, :link_record => @cm.resource) }
        all_cms = FindCodemarks.new(:by => :visits)
        all_cms.codemarks.first.visit_count.should == "2"
      end
    end

    context "with paging" do
      it "can take the result from a query and page it" do
        codemarks = FindCodemarks.new(:user => @user, :page => 1, :per_page => 1)
        codemarks.codemarks.all.count.should == 1
      end

      it "defaults to 25 per page" do
        25.times do
          Fabricate(:codemark_record)
        end
        response = FindCodemarks.new
        response.codemarks.all.count.should == FindCodemarks::PAGE_SIZE
      end

      it 'returns total pages' do
        response = FindCodemarks.new(:user => @user, :per_page => 9999)
        response.codemarks.num_pages.should == 1
      end
    end

    context 'with query' do
      xit 'searches a codemarks title', :travis_skip => true do
        cm = Fabricate(:codemark_record, :user => @user, :title => 'My pretty pony')
        FindCodemarks.new(:search_term => 'pony').codemarks.collect(&:id).should =~ [cm.id]
      end
    end
  end

  context 'there are no codemarks' do
    it 'should not be nil' do
      FindCodemarks.new.should_not be_nil
    end
  end

end
