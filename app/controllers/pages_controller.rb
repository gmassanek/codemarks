class PagesController < ApplicationController

  layout 'pages'

  autocomplete :topic, :title, :full => true, :extra_data => [:slug]

  def landing
    redirect_to short_user_path(current_user) if logged_in?
    @codemarks = FindCodemarks.new().codemarks
  end

  def codemarklet_test
    render :layout => nil
  end

end
