require 'spec_helper'

describe "topics" do
  describe "while signed in" do
    before do
      simulate_signed_in
    end

    it "lets you save a new topics" do
      visit new_topic_path
      page.fill_in :title, with: "Incoming Email Parser"
      page.click_button "Create Topic"
      page.should have_content "Topic created"
    end

    it "has an index" #do
    #  3.times { Fabricate(:topic) }
    #  count = Topic.count
    #  visit topics_path
    #  page.should have_selector("li.topic", :count => 3)
    #end
  end

  describe "as a visitor" do
    it "has an index" do
      3.times { Fabricate(:topic) }
      count = Topic.count
      visit topics_path
      page.should have_selector("li.topic", :count => 3)
    end
  end

  describe "show" do
    before do
      @github = Fabricate(:topic, title: "Github")
      @rspec = Fabricate(:topic, title: "Rspec")
      @codemark = Fabricate(:codemark_record, topics: [@rspec])
      @codemark2 = Fabricate(:codemark_record, topics: [@rspec, @github])
    end

    it "doesn't break on the show page" do
      visit topic_path(@rspec)
    end
    
    it "shows all codemarks for a topic on topic show page"
  end
end
