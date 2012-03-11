require 'spec_helper'

describe "User pages" do
  context "Show" do
    context "viewing my own page" do
      before do
        simulate_signed_in
      end

      context "filters" do
        before do
          @my_codemark = Fabricate(:codemark_record, :user => @user)
          @his_codemark = Fabricate(:codemark_record)
        end

        context "mine" do
          it "is the default" do
            visit short_user_path(@user)
            page.should have_link @my_codemark.title
            page.should_not have_link @his_codemark.title
          end
        end
      end
    end
  end
end
