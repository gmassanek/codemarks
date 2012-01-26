require 'spec_helper'
require 'tagger'

include OOPs

describe Tagger do
  let(:link) { Fabricate(:link, url: "http://www.google.com") }
  let(:smart_link) { SmartLink.new(link) }

  it "finds no tags if the link has no response" do
    Tagger.get_tags_for_link(link).should be_nil
  end

  it "finds the topics for a smartlink" do
    google = Fabricate(:topic, title: "google")
    not_google = Fabricate(:topic, title: "goadfjadfafdogle")
    link = smart_link.better_link
    Tagger.get_tags_for_link(link).should include(google)
    Tagger.get_tags_for_link(link).should_not include(not_google)
  end

  context "stubbing pain is showing me that I need to change code" do
    it "finds content tags" do
      Fabricate(:topic, title: "rspec")
      Fabricate(:topic, title: "github")
      content = "Rspec and github content"
      response = stub(:response, :content => content)
      link.should_receive(:response).and_return(response)
      Tagger.get_tags_for_link(link).length.should == 2
    end

    it "finds title tags" do
      Fabricate(:topic, title: "rspec")
      Fabricate(:topic, title: "github")
      Fabricate(:topic, title: "google")
      title = "Rspec and github content"
      content = "Rspec and github content"
      response = stub(:response, :content => content)
      link = stub(:link, response: response)
      link.should_receive(:title).and_return(title)
      Tagger.get_tags_for_link(link).length.should == 2
    end

    describe "lots of guys" do
      let(:titles) { ["rspec", "github", "google", "cucumber", "jquery", "another item"] }
      before do
        titles.each { |title| Fabricate(:topic, title: title) }
      end

      it "returns only 5" do
        response_title = titles.join(" ")
        content = "no tags here"
        response = stub(:response, :content => content)
        link = stub(:link, response: response)
        link.should_receive(:title).and_return(response_title)
        Tagger.get_tags_for_link(link).length.should == 5
      end

      it "selects title tags first" do
        response_title = titles[0..-2].join(" ")
        content = titles.last
        response = stub(:response, :content => content)
        link = stub(:link, response: response)
        link.should_receive(:title).and_return(response_title)
        Tagger.get_tags_for_link(link).collect(&:title).should == titles[0..-2]
      end

      it "combines title and content tags" do
        response_title = titles[0..-3].join(" ")
        content = titles[-2..-1].join(" ")
        response = stub(:response, :content => content)
        link = stub(:link, response: response)
        link.should_receive(:title).and_return(response_title)
        Tagger.get_tags_for_link(link).collect(&:title).should == titles[0..-2]
      end
    end
  end
end
