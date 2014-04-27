require 'spec_helper'

describe FindCodemarks do
  context '#codemarks' do
    before do
      @user = Fabricate(:user)
      @cm = Fabricate(:codemark, :user => @user, :topics => [Fabricate(:topic), Fabricate(:topic)])
      @cm2 = Fabricate(:codemark, :user => @user)
    end

    it 'can be empty' do
      FindCodemarks.new.should_not be_nil
    end

    it "should find all codemarks regardless of user" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark, :user => user)
      all_cms = FindCodemarks.new
      all_cms.codemarks.should =~ [@cm, @cm2, @cm3]
    end

    it "doesn't return multiple cms for the same link" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark, :user => user, :resource => @cm.resource)
      all_cms = FindCodemarks.new
      all_cms.codemarks.all.count.should == 2
    end

    it "returns my cm even if other people saved the same link" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark, :user => user, :resource => @cm.resource)
      all_cms = FindCodemarks.new(:user => @user)
      all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
    end

    it "returns the save count" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark, :user => user, :resource => @cm.resource)
      all_cms = FindCodemarks.new
      all_cms.codemarks.first.save_count.should == "2"
    end

    it "returns the save count for text" do
      user = Fabricate(:user)
      text_cm = Fabricate(:codemark, :user => user, :resource => Text.create!(:text => 'text'))
      all_cms = FindCodemarks.new(:user => user)
      all_cms.codemarks.first.save_count.should == "1"
    end

    it "returns the save count for a repo" do
      user = Fabricate(:user)
      repo_cm = Fabricate(:codemark, :user => user, :resource => Repository.create!(:title => 'title'))
      all_cms = FindCodemarks.new(:user => user)
      all_cms.codemarks.first.save_count.should == "1"
    end

    it "textmarks for anonymous users" do
      user = Fabricate(:user)
      text_cm = Fabricate(:codemark, :user => user, :resource => Text.create!(:text => 'text'))
      Fabricate(:codemark, :user => user, :resource => text_cm.resource)
      all_cms = FindCodemarks.new(:by => 'popularity')
      all_cms.codemarks.first.save_count.should == "2"
    end

    it "returns the save count when scoped by user" do
      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark, :user => user, :resource => @cm.resource)
      all_cms = FindCodemarks.new(:user => user)
      all_cms.codemarks.first.save_count.should == "2"
    end

    it "returns the resource author" do
      @cm.resource.update_attributes(:author => @user)

      user = Fabricate(:user)
      @cm3 = Fabricate(:codemark, :user => user, :resource => @cm.resource)
      codemarks  = FindCodemarks.new.codemarks
      codemarks.first.resource_author.should == @user
    end

    context "for a user" do
      let(:find_by_user) { FindCodemarks.new(:user => @user) }

      it "gets all the Codemarks" do
        find_by_user.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
      end

      it "returns the codemarks of the current_user" do
        Fabricate(:codemark, :user => Fabricate(:user), :resource => @cm.resource)
        FindCodemarks.new(:current_user => @user).codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
      end

      it "returns an ActiveRecord::Relation" do
        find_by_user.codemarks.should be_a ActiveRecord::Relation
      end
    end

    context '#groups' do
      let(:group) { Group.create!(:name => 'Foobars') }
      let(:group2) { Group.create!(:name => 'Boohoobars') }

      it 'does include codemarks in no group' do
        codemark = Fabricate(:codemark)
        all_cms = FindCodemarks.new(:current_user => @user)
        all_cms.codemarks.collect(&:id).should include codemark.id
      end

      it 'does not include codemarks in no group if a group is specified' do
        @user.groups = [group]
        codemark = Fabricate(:codemark)
        all_cms = FindCodemarks.new(:current_user => @user, :group_ids => [group.id])
        all_cms.codemarks.collect(&:id).should_not include codemark.id
      end

      it 'does include codemarks in my group' do
        @user.groups << group
        codemark = Fabricate(:codemark, :group => group)
        all_cms = FindCodemarks.new(:current_user => @user)
        all_cms.codemarks.collect(&:id).should include codemark.id
      end

      it 'does not include codemarks in other people\'s groups' do
        user = Fabricate(:user, :groups => [group2])
        codemark = Fabricate(:codemark, :group => group2, :user => user)
        all_cms = FindCodemarks.new(:current_user => @user)
        all_cms.codemarks.collect(&:id).should_not include codemark.id
      end

      it 'only selects from a specific group if specified' do
        user = Fabricate(:user, :groups => [group2])
        codemark1 = Fabricate(:codemark, :group => group, :user => user)
        codemark2 = Fabricate(:codemark, :group => group2, :user => user)
        all_cms = FindCodemarks.new(:current_user => user, :group_ids => [group2.id])
        all_cms.codemarks.collect(&:id).should include codemark2.id
        all_cms.codemarks.collect(&:id).should_not include codemark1.id
      end

      it 'never selects groups I cannot see' do
        user = Fabricate(:user, :groups => [group])
        codemark = Fabricate(:codemark, :group => group2)
        all_cms = FindCodemarks.new(:current_user => user, :group_ids => [group2.id])
        all_cms.codemarks.collect(&:id).should_not include codemark.id
      end

      it 'never selects anything from a groups for anonymous users' do
        codemark = Fabricate(:codemark, :group => group2)
        all_cms = FindCodemarks.new(:group_ids => [group2.id])
        all_cms.codemarks.collect(&:id).should_not include codemark.id
      end
    end

    describe 'privateness' do
      let(:user) { Fabricate(:user) }
      let(:private) { Topic.find_by_title('private') || Fabricate(:topic, :title => 'private') }

      it 'does not include other users private codemarks' do
        private_codemark = Fabricate(:codemark, :topics => [private], :user => user)
        all_cms = FindCodemarks.new(:current_user => @user)
        all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
      end

      it 'does not include other users private codemarks' do
        user = Fabricate(:user)
        private_codemark = Fabricate(:codemark, :private => true, :user => user)
        all_cms = FindCodemarks.new(:user => @user, :current_user => user)
        all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
      end

      it 'does not hide partially private codemarks' do
        user2 = Fabricate(:user)
        private_codemark = Fabricate(:codemark, :topics => [private], :user => user2, :resource => @cm.resource)
        all_cms = FindCodemarks.new
        all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id]
      end

      it 'does include my private codemarks' do
        private_codemark = Fabricate(:codemark, :private => true, :user => @user)
        all_cms = FindCodemarks.new(:user => @user, :current_user => @user)
        all_cms.codemarks.collect(&:id).should =~ [@cm.id, @cm2.id, private_codemark.id]
      end
    end

    context "for a topic" do
      let(:topic1_id) { @cm.topics.first.id }
      let(:topic2_id) { @cm.topics.last.id }

      it "gets all the Codemarks" do
        cm3 = Fabricate(:codemark, :topic_ids => [topic1_id])
        cms = FindCodemarks.new(:topic_ids => [topic1_id]).codemarks
        cms.collect(&:id).should =~ [@cm.id, cm3.id]
      end

      describe 'with multiple topics' do
        it 'does not find a codemark that only matches one of the topics' do
          cm3 = Fabricate(:codemark, :topic_ids => [topic1_id])
          cms = FindCodemarks.new(:topic_ids => [topic1_id, topic2_id]).codemarks
          cms.should == [@cm]
        end
      end
    end

    context "ordering" do
      it "defaults to ordering by most recently created" do
        @cm.update_attribute(:created_at, 9.days.ago)
        @cm2.update_attribute(:created_at, 3.days.ago)
        @cm3 = Fabricate(:codemark, :created_at => 5.days.ago)
        all_cms = FindCodemarks.new
        all_cms.codemarks.collect(&:id).should == [@cm2.id, @cm3.id, @cm.id]
      end

      it "can be ordered by save_count" do
        user = Fabricate(:user)
        @cm3 = Fabricate(:codemark, :user => user, :resource => @cm.resource)
        @cm4= Fabricate(:codemark, :user => @user)

        all_cms = FindCodemarks.new(:by => :count)
        all_cms.codemarks.first.save_count.should == "2"
      end

      it "can be ordered by visit_count" do
        text_cm = Fabricate(:codemark, :user => @user, :resource => Text.create!(:text => 'text'))
        user = Fabricate(:user)
        2.times { Fabricate(:click, :user => user, :resource => @cm2.resource) }
        3.times { Fabricate(:click, :user => user, :resource => text_cm.resource) }

        all_cms = FindCodemarks.new(:by => :visits)
        all_cms.codemarks.first.visit_count.should == "3"
        all_cms.codemarks.first.visit_count.should == "3"
      end

      describe 'by popularity' do
        before do
          Codemark.destroy_all
        end

        it "includes visits and saves" do
          resource1 = Fabricate(:codemark).resource
          resource2 = Fabricate(:codemark).resource
          resource3 = Fabricate(:codemark).resource
          3.times { Fabricate(:click, :resource => resource1) }
          1.times { Fabricate(:click, :resource => resource2) }
          2.times { Fabricate(:click, :resource => resource3) }

          2.times { Fabricate(:codemark, :resource => resource1) } # 5
          2.times { Fabricate(:codemark, :resource => resource2) } # 3
          5.times { Fabricate(:codemark, :resource => resource3) } # 7

          all_cms = FindCodemarks.new(:by => :popularity)
          all_cms.codemarks[0].resource.id.should == resource3.id
          all_cms.codemarks[1].resource.id.should == resource1.id
          all_cms.codemarks[2].resource.id.should == resource2.id
        end
      end

      describe 'by buzzing' do
        before do
          Codemark.destroy_all
        end

        it "values recently visited codemarks" do
          resource1 = Fabricate(:codemark, :created_at => 3.days.ago).resource
          resource2 = Fabricate(:codemark, :created_at => 3.hours.ago).resource
          resource3 = Fabricate(:codemark, :created_at => 10.minutes.ago).resource
          2.times { Fabricate(:click, :resource => resource2) }

          all_cms = FindCodemarks.new(:by => :buzzing)
          all_cms.codemarks.map(&:resource_id).should == [resource2.id, resource3.id, resource1.id]
        end

        it "does not require much to bump up a few days" do
          resource1 = Fabricate(:codemark, :created_at => 4.days.ago).resource
          resource2 = Fabricate(:codemark, :created_at => 8.hours.ago).resource
          resource3 = Fabricate(:codemark, :created_at => 10.minutes.ago).resource
          4.times { Fabricate(:click, :resource => resource1) }

          all_cms = FindCodemarks.new(:by => :buzzing)
          all_cms.codemarks.map(&:resource_id).should == [resource3.id, resource2.id, resource1.id]
        end

        it "does not overload crazy ones" do
          resource1 = Fabricate(:codemark, :created_at => 3.months.ago).resource
          resource2 = Fabricate(:codemark, :created_at => 1.month.ago).resource
          50.times { begin; Fabricate(:click, :resource => resource1) rescue retry; end}
          5.times { Fabricate(:click, :resource => resource2) }

          all_cms = FindCodemarks.new(:by => :buzzing)
          all_cms.codemarks.map(&:resource_id).should == [resource2.id, resource1.id]
        end
      end
    end

    context "with paging" do
      before do
        Codemark.destroy_all

        5.times do
          begin
            Fabricate(:codemark)
          rescue ActiveRecord::RecordInvalid
            retry
          end
        end
      end

      it "defaults to 24 per page" do
        FindCodemarks.new.codemarks.first.page_size.should == "24"
      end

      it 'returns total count' do
        FindCodemarks.new.codemarks.first.full_count.should == "5"
      end

      it 'can limit page size' do
        FindCodemarks.new(:per_page => 2).codemarks.should have(2).items
      end

      it 'can request a given page' do
        FindCodemarks.new(:per_page => 2, :page => 1).codemarks.should_not == FindCodemarks.new(:per_page => 2, :page => 2).codemarks
      end
    end

    context 'with query', :search_indexes => true do
      it 'searches a codemarks title' do
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony')
        FindCodemarks.new(:search_term => 'pony').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'searchs a links content' do
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony')
        cm.resource.update_attributes(:site_data => 'MacMahan Island')
        FindCodemarks.new(:search_term => 'MacMahan').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'searches a texts title' do
        text = Text.create!(:title => 'Some cool new tool')
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony', :resource => text)
        FindCodemarks.new(:search_term => 'cool new tool').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'searches a repos description' do
        repo = Repository.create!(:description => 'Some cool new tool')
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony', :resource => repo)
        FindCodemarks.new(:search_term => 'cool new tool').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'searches a repos owner' do
        repo = Repository.create!(:owner_login => 'gmassanek')
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony', :resource => repo)
        FindCodemarks.new(:search_term => 'gmassanek').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'matches topics from search' do
        topic = Fabricate(:topic, :title => 'Github')
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony', :topics => [topic])
        FindCodemarks.new(:search_term => 'github').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'matches any topics from search' do
        topic = Fabricate(:topic, :title => 'Github')
        topic2 = Fabricate(:topic, :title => 'Github2')
        cm = Fabricate(:codemark, :user => @user, :title => 'My pretty pony', :topics => [topic])
        FindCodemarks.new(:search_term => 'github').codemarks.collect(&:id).should =~ [cm.id]
      end

      it 'matches title even if no topics match' do
        topic = Fabricate(:topic, :title => 'Github')
        cm = Fabricate(:codemark, :user => @user, :title => 'Github rocks')
        FindCodemarks.new(:search_term => 'github').codemarks.collect(&:id).should =~ [cm.id]
      end

      it "uses the sort passed in" do
        cm1 = Fabricate(:codemark, :user => @user, :title => 'My pretty pony')
        cm3 = Fabricate(:codemark, :user => @user, :title => 'My boring pony')
        cm2 = Fabricate(:codemark, :user => @user, :title => 'My ugly pony')
        2.times { Fabricate(:click, :user => @user, :resource => cm2.resource) }

        all_cms = FindCodemarks.new(:by => :visits, :search_term => 'pony')
        all_cms.codemarks.first.visit_count.should == "2"
      end
    end
  end

  context '#find_topic_ids_from_search_query', :search_indexes => true do
    it 'matches topics that match the search query' do
      topic = Fabricate(:topic, :title => 'Github')
      matched_topic_ids = FindCodemarks.new(:search_term => 'github').find_topic_ids_from_search_query
      matched_topic_ids.should == [topic.id]
    end

    it 'is an empty array if there is no search term' do
      matched_topic_ids = FindCodemarks.new.find_topic_ids_from_search_query
      matched_topic_ids.should == []
    end
  end
end
