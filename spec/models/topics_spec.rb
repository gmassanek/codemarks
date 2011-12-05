require 'spec_helper'

describe Topic do
  
  describe "validations" do
    let(:topic) { Fabricate.build(:topic) }

    it "requires a title" do
      topic.title = nil
      topic.should_not be_valid
    end

    it "needs a unique title" do
      topic.save
      dup_topic = Fabricate.build(:topic, :title => topic.title)
      dup_topic.should_not be_valid
    end

    it "has 0 sponsored_sites as a new topic" do
      topic  = Fabricate(:topic)
      topic.sponsored_sites.should be_empty
    end
  end


  describe "sponsored sites" do
    
    it "can be saved through a topic", :broken => true do
      topic_atts = Fabricate.attributes_for(:topic)
      full_site_atts = Fabricate.attributes_for(:sponsored_site, :topic => nil)
      empty_site_atts = Fabricate.attributes_for(:sponsored_site, :url => nil, :site => nil, :topic => nil)
      topic_atts[:sponsored_sites_attributes] = {"0" => full_site_atts, "1" => empty_site_atts}
      #topic = Topic.create(topic_atts)
      #ICKKKKKK
      topic = Topic.create({"title"=>"Rspec2", "description"=>"", "sponsored_sites_attributes"=>{"0"=>{"topic_id"=>"2", "site"=>"twitter", "url"=>"http://www.twitter.com"}, "1"=>{"topic_id"=>"2", "site"=>"github", "url"=>""}}})
      topic.sponsored_sites.count.should == 1
    end

    it "deletes the sponsored link when a topic is deleted" do
      topic = Fabricate(:topic_with_sponsored_links)
      lambda do
        topic.destroy
      end.should change(SponsoredSite, :count).by(-3)
    end

  end


  describe "scopes" do
    before do
      @lt = Fabricate(:link_topic)
      @lt2 = Fabricate(:link_topic, :topic => @lt.topic)
      @alt = Fabricate(:link_topic)
      @plt = Fabricate(:private_link_topic)
    end
    let(:user) { Fabricate(:user_with_private_link) }
    let(:user2) { Fabricate(:user) }

    it "gets all public links" do
      Topic.all_public.collect(&:id).should == [@lt.topic, @alt.topic].collect(&:id)
    end

    it "gets all public links plus user's private links" do
      Topic.public_and_for_user(user).collect(&:id).should =~ user.topics.collect(&:id) | Topic.all_public.collect(&:id)
    end

    it "gets all a user's private links if there is a user and is filtered" do
      Topic.for_user(user).should == user.topics
    end

    context "resource counts" do
      it "gives count of all public links if there is no user"
      it "gives count of all public links plus user's private links if there is a user, not filtered"
      it "gives count of all a user's private links if there is a user and is filtered"
    end
  end
end
