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

    context "are unique" do
      let (:link) {Fabricate(:link)}
      let (:link2) {Fabricate.build(:link)}

      it "requires a unique url" do
        link2.url = link.url
        link2.should_not be_valid
      end
      
      it "starts save_count at 1" do
        link.save_count.should == 1
      end

      it "increments the count of an existing link when bookmarked again", :broken => true do
        link2_atts = Fabricate.attributes_for(:link)
        link2_atts[:url] = link.url

        attributes = {}
        attributes[:link] = link2_atts
        ResourceManager::LinkSaver.create_new_link(attributes)
      end
    end

    context "updates topics properly" do
      let(:topic1) { Fabricate(:topic) }
      let(:topic2) { Fabricate(:topic) }

      it "saves by adding topics on update", :broken => true do
        link = Fabricate(:link, :topic_ids => [topic1.id])
        link2_atts = Fabricate.attributes_for(:link)

        attributes = {}
        attributes[:link] = link2_atts
        attributes[:topic_ids] = [topic2.id]
        ResourceManager::LinkSaver.create_new_link(attributes)

        link = Link.first
        link.topic_ids.should == [topic1.id, topic2.id]

        link2_atts = Fabricate.attributes_for(:link)
        link2_atts[:url] = link.url

      end
    end
  end

  describe "topics associations" do
    it "accepts and creates topic associations" do
      link_atts = Fabricate.attributes_for(:link)
      topic1 = Fabricate(:topic)
      topic2 = Fabricate(:topic)
      link_atts[:topic_ids] = [topic1.id, topic2.id]
      lambda do
        l = Link.create(link_atts)
      end.should change(LinkTopic, :count).by(2)
    end

    it "requires at least one topic association"
  end

  it "finds the title from the actual site if none is present" do
    link = Fabricate(:link, :url => "http://www.google.com", :title => nil)
    link.title.should == "Google"
  end

end
