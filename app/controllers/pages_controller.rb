class PagesController < ApplicationController

  autocomplete :topic, :title, :full => true, :extra_data => [:slug]

  def landing
    redirect_to short_user_path(current_user) if logged_in?
  end

  def codemarklet_test
    render :layout => nil
  end

end
