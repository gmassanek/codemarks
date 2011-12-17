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
end
