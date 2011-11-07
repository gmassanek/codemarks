require 'spec_helper'

describe Link do

  it "requires a title" do
    link = Fabricate.build(:link)
    link.title = nil
    link.should_not be_valid
  end

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
      link_atts[:link_topics_attributes] = {"0" => {:topic_id => topic1.id}, "1" => {:topic_id => topic2.id}}
      lambda do
        l = Link.create(link_atts)
      end.should change(LinkTopic, :count).by(2)
    end

    it "requires at least one topic association"
  end

  describe "smart links" do

    it "finds the title of the page if no title is provided" do
      link = Fabricate.build(:link)
      link.title = nil
      link.valid?
      link.title.should_not be_nil
    end

  end
end
