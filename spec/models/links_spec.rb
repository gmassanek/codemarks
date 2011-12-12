require 'spec_helper'

describe Link do

  describe "URLs" do
    let (:link) { Fabricate.build(:link) }

    it "are required" do
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

  #describe "has all sorts of scopes" do
  #  before do
  #    @lt = Fabricate(:link_topic)
  #    @lt2 = Fabricate(:link_topic)
  #    @plt = Fabricate(:private_link_topic)
  #  end
  #  
  #  it "find all public Links" do
  #    Link.all_public.should == [@lt.link, @lt2.link]
  #  end

  #  it "returns a list of distinct topics for a group of links" do
  #    links = 3.times { Fabricate(:link) }
  #    Link.topics(Link.scoped).should == Topic.all
  #  end

  #  it "filters down by topic" do
  #    link_topic = Fabricate(:link_topic, :topic => @lt.topic)
  #    Link.for_topic(@lt.topic).should == [@lt.link, link_topic.link]
  #  end

  #  it "sorts by popularity" do
  #    2.times { Fabricate(:link_save, :link => @lt2.link) }
  #    Link.by_popularity.first.should == @lt2.link
  #  end

  #  it "sorts by by_create_date" do
  #    Link.by_create_date.first.should == Link.last
  #  end

  #  #it "returns most popular for a given topic" do
  #  #  2.times { Fabricate(:link_save, :link => @lt.link) }
  #  #  Fabricate(:link_topic, :topic => @lt.topic)
  #  #  Link.most_popular_for(@lt.topic).first.should == @lt.link
  #  #end

  #end


  #it "finds the title from the actual site if none is present" do
  #  link = Fabricate(:link, :url => "http://www.google.com", :title => nil)
  #  link.title.should == "Google"
  #end


  #it "is not private by default" do
  #  link = Fabricate(:link)
  #  link.should_not be_private
  #end

end
