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
      visit root_path
      page.should have_css("input#url", :visible => true)
    end
    
    it "shows the second form when I submit a URL to save", js: true do
      visit root_path
      page.fill_in("url", :with => "http://www.google.com")
      page.click_button("fetch")
      page.should have_css("#new_codemark", :visible => true)
      page.find_field("codemark_link_title").value.should == "Google"
    end

    it "shows the second form when I submit a URL to save even if it couldn't fetch the url", js: true do
      visit root_path
      page.fill_in("url", :with => "http://www.234fggg_oogle2342adfa23r4.com")
      page.click_button("fetch")
      page.should have_css("#new_codemark", :visible => true)
      page.find_field("codemark_link_title").value.should == ""
    end

    it "saves a new link_save", js: true, :broken => true do
      # TODO Not getting tagged with any topics and it's blowing up
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

    it "won't let a user click save without any topics", js: true do
      visit root_path
      page.fill_in("url", :with => "http://www.google.com")
      page.click_button("fetch")
      page.should_not have_css("li.topic")
      page.should have_xpath("//input[@name='commit' and @disabled]")
    end

    it "will save a link (cheating to have it match one)", broken: true do
      codemark = Fabricate(:codemark)
      visit root_path
      page.fill_in("url", :with => codemark.link.url)
      page.click_button("fetch")

      Codemarker.should_receive(:mark!)
      save_and_open_page
      page.click_button("Create Codemark")
    end

    it "creates a topic for one that was entered", broken: true do
      visit dashboard_path
      page.fill_in "url", with: "http://www.google.com"
      page.click_button "fetch"
      page.fill_in "link_form_topic_autocomplete", with: "search engine"

    end
  end
  it "records clicks", js: true, broken: true do
    simulate_signed_in
    codemark = Fabricate(:codemark, user: @user)
    puts codemark.inspect
    puts @user.codemarks.inspect
    puts Codemark.all.inspect
    visit dashboard_path
    lambda {
      page.click_link codemark.link.title
    }.should change(Click, :count).by(1)
  end

end

