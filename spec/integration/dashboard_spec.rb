require 'spec_helper'

describe "User pages" do
  context "Dashboard" do
    it "requires a logged in user" do
      @user = Fabricate(:user)
      visit dashboard_path
      current_path.should == root_path
    end

    context "viewing my own page" do
      before do
        simulate_signed_in
      end

      context "filters" do
        before do
          @my_codemark = Fabricate(:codemark, :user => @user)
          @his_codemark = Fabricate(:codemark)
        end

        context "mine" do
          it "is the default" do
            visit dashboard_path
            page.should have_link @my_codemark.title
            page.should_not have_link @his_codemark.title
          end
        end

        context "public" do
          it "shows all links, including mine" do
            visit dashboard_path
            page.click_link "public codemarks"
            page.should have_link @my_codemark.title
            page.should have_link @his_codemark.title
          end

          it "only shows a link once, even if it has been saved multiple times" do
            second_save = Fabricate(:codemark, link: @his_codemark.link)
            visit dashboard_path
            page.click_link "public codemarks"
            page.should have_link @my_codemark.title
            page.should have_xpath("//a[contains(@href,'#{@his_codemark.url}')]", :count => 1)
          end
        end

        context "archived" do
          #it "unarchived links by default" do
          #  new_link = Fabricate(:codemark, :user => @user, :archived => false)
          #  old_link = Fabricate(:codemark, :user => @user, :archived => true)
          #  visit dashboard_path
          #  page.should have_link new_link.title
          #  page.should_not have_link old_link.title
          #end

          #it "archived and unarchived links when I ask for them" do
          #  new_link = Fabricate(:codemark, :user => @user, :archived => false)
          #  old_link = Fabricate(:codemark, :user => @user, :archived => true)
          #  visit dashboard_path
          #  page.click_link "view archived"
          #  page.should have_link new_link.title
          #  page.should have_link old_link.title
          #end

          #it "doesn't show the archived option unless I'm looking at my links" do
          #  visit dashboard_path
          #  page.click_link "public codemarks"
          #  page.should_not have_link "view archived"
          #end
        end
      end

      context "sorts" do
        it "by save date by default", js: true, broken: true do
          old_ls = Fabricate(:codemark, :user => @user, :created_at => 3.years.ago)
          new_ls = Fabricate(:codemark, :user => @user, :created_at => 3.minutes.ago)
          med_ls = Fabricate(:codemark, :user => @user, :created_at => 3.days.ago)
          visit dashboard_path
          page.click_link "by save date"
          puts Codemark.all.inspect
          save_and_open_page
          within("#codemarks li:first-child") do
            page.should have_link new_ls.title
          end
          within("#codemarks li:last-child") do
            page.should have_link old_ls.title
          end
        end

        it "by popularity default when requested", :broken => true do
          boring = Fabricate(:codemark, :user => @user)
          3.times { Fabricate(:click, link: boring.link, :user => @user) }
          popular = Fabricate(:codemark, :user => @user)
          9.times { Fabricate(:click, link: popular.link, :user => @user) }
          pretty_good = Fabricate(:codemark, :user => @user)
          5.times { Fabricate(:click, link: pretty_good.link, :user => @user) }

          visit dashboard_path + "?sort=by_popularity"
          puts "just clicked 'by popularity'"
          within("#code_marks li:first-child") do
            page.should have_link popular.title
          end
          within("#code_marks li:last-child") do
            page.should have_link boring.title
          end
        end
      end

      context "combo sorts and filters", broken: true, js: true do
        it "maintains a filter after you click a new sort" do
          my_ls = Fabricate(:codemark, :user => @user)
          my_ls2 = Fabricate(:codemark, :user => @user)
          his_ls = Fabricate(:codemark)

          visit dashboard_path
          page.should_not have_link his_ls.title
          page.click_link "public codemarks"
          page.should have_link his_ls.title
          page.click_link "by popularity"
          page.should have_link his_ls.title
        end
      end
    end
  end
end
