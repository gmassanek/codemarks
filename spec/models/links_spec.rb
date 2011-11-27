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

  it "is public by default" do
    link = Fabricate(:link)
    link.should be_public
  end
end
