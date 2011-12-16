require 'spec_helper'

describe "New Codemark Form" do
  it "is hidden if you're not logged in" do
    visit root_path
    page.should_not have_css("input#url", :visible => true)
  end

  context "submission" do
    before do
      simulate_signed_in
    end

    it "is on any page if you're logged in" do
      simulate_signed_in
      visit root_path
      page.should have_css("input#url", :visible => true)
    end
    
    it "shows the second form when I submit a URL to save", js: true do
      simulate_signed_in
      visit root_path
      page.fill_in("url", :with => "http://www.google.com")
      page.click_button("fetch")
      page.should have_css("#full_link_form", :visible => true)
      page.find_field("link_title").value.should == "Google"
    end

    it "shows the second form when I submit a URL to save even if it couldn't fetch the url", js: true do
      simulate_signed_in
      visit root_path
      page.fill_in("url", :with => "http://www.234fggg_oogle2342adfa23r4.com")
      page.click_button("fetch")
      page.should have_css("#full_link_form", :visible => true)
      page.find_field("link_title").value.should == ""
    end

    it "saves a new link_save", js: true, :broken => true do
      # TODO Not getting tagged with any topics and it's blowing up
      simulate_signed_in
      google = Fabricate(:topic, :title => "news")
      visit root_path
      page.fill_in("url", :with => "http://www.google.com")
      page.click_button("fetch")
      page.should have_css("#full_link_form", :visible => true)
      page.should have_css("#topic_tags ul li:first-child")
      LinkSaver.should_receive(:save_link!)
      lambda {
        page.click_button("Create Link")
        current_path.should == root_path
        page.should have_content "Link created"
      }.should change(LinkSave, :count).by(1)
    end
  end
end

