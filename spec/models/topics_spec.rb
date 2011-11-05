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
    
    it "can be saved through a topic" do
      topic_atts = Fabricate.attributes_for(:topic)
      full_site_atts = Fabricate.attributes_for(:sponsored_site, :topic => nil)
      empty_site_atts = Fabricate.attributes_for(:sponsored_site, :url => nil, :site => nil, :topic => nil)
      topic_atts[:sponsored_sites_attributes] = {"0" => full_site_atts, "1" => empty_site_atts}
      #topic = Topic.create(topic_atts)
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


end
