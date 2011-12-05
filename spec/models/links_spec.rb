require 'spec_helper'

describe Link do

  describe "URLs" do
    let (:link) { Fabricate.build(:link) }

    it "requires a url" do
      link.url = nil
      link.should_not be_valid
    end

    ["http://www.twitter.com", "https://twitter"].each do |url|
      it "accepts #{url}" do
        link.url = url
        link.should be_valid
      end
    end

    ["twitter.com", "twitter", "www.twitter.com"].each do |url|
      it "rejects #{url}" do
        link.url = url
        link.should_not be_valid
      end
    end

    it "requires a unique url" do
      link.save
      link2 = Fabricate.build(:link, :url => link.url)
      link2.should_not be_valid
    end
  end

  describe ResourceManager::LinkSaver do
    let (:topic) {Fabricate(:topic)}
    let (:topic2) {Fabricate(:topic)}
    let (:link_atts) {Fabricate.attributes_for(:link)}

    context "counting link saves" do
      it "manages save counts using LinkSave objects" do
        lambda do
          ResourceManager::LinkSaver.create_link(link_atts, [topic.id], 0, nil)
        end.should change(LinkSave, :count).by(1)
      end

      it "starts save_count at 1" do
        link = ResourceManager::LinkSaver.create_link(link_atts, [topic.id], 0, nil)
        link.save_count.should == 1
      end

      it "increments the count of an existing link when bookmarked again" do
        link = ResourceManager::LinkSaver.create_link(link_atts, [topic.id], 0, nil)
        link2 = ResourceManager::LinkSaver.create_link(link_atts, [topic2.id], 0, nil)
        link.should == link2
        link.save_count.should == 2
      end
    end

    it "adds to the topic associations when saved again" do
      ResourceManager::LinkSaver.create_link(link_atts, [topic.id], 0, nil)
      link = ResourceManager::LinkSaver.create_link(link_atts, [topic2.id], 0, nil)
      link.topic_ids.should == [topic.id, topic2.id]
    end
  end

  it "finds the title from the actual site if none is present" do
    link = Fabricate(:link, :url => "http://www.google.com", :title => nil)
    link.title.should == "Google"
  end

  it "requires at least one topic"

  it "is not private by default" do
    link = Fabricate(:link)
    link.should_not be_private
  end

  describe "has all sorts of scopes" do
    before do
      @lt = Fabricate(:link_topic)
      @lt2 = Fabricate(:link_topic)
      @plt = Fabricate(:private_link_topic)
    end
    
    it "find all public Links" do
      Link.all_public.should == [@lt.link, @lt2.link]
    end

    it "returns a list of distinct topics for a group of links" do
      links = 3.times { Fabricate(:link) }
      Link.topics(Link.scoped).should == Topic.all
    end

    it "filters down by topic" do
      link_topic = Fabricate(:link_topic, :topic => @lt.topic)
      Link.for_topic(@lt.topic).should == [@lt.link, link_topic.link]
    end

    it "sorts by popularity" do
      2.times { Fabricate(:link_save, :link => @lt2.link) }
      Link.by_popularity.first.should == @lt2.link
    end

    it "sorts by by_create_date" do
      Link.by_create_date.first.should == Link.last
    end

    it "returns most popular for a given topic" do
      2.times { Fabricate(:link_save, :link => @lt.link) }
      Fabricate(:link_topic, :topic => @lt.topic)
      Link.most_popular_for(@lt.topic).first.should == @lt.link
    end

  end

  describe "popularity" do
    it "increases with a link save" do
      lt = Fabricate(:link_topic)
      Fabricate(:link_save, :link => lt.link)
      Link.last.popularity.should == 1
    end
    it "increases with a link click" do
      lt = Fabricate(:link_topic)
      Fabricate(:click, :link => lt.link)
      Link.last.popularity.should == 1
    end
  end
end
