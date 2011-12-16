require 'spec_helper'

describe "topics" do
  before do
    simulate_signed_in
  end

  it "lets you save a new topics" do
    visit new_topic_path
    page.fill_in :title, with: "Incoming Email Parser"
    page.click_button "Create Topic"
    save_and_open_page
    page.should have_content "Topic created"
  end

  it "has an index" do
    5.times { Fabricate(:topic) }
    count  = Topic.count
    visit topics_path
    #save_and_open_page
    page.should have_css("ul#topics li", count: 5)
  end
end
