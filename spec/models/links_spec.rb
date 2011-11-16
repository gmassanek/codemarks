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

  describe "smart links" do

    it "finds the title from the actual site if none is present" do
      link = Fabricate(:link, :url => "http://www.google.com", :title => nil)
      link.title.should == "Google"
    end

  end
end
