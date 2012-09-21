class PagesController < ApplicationController

  layout 'pages'

  autocomplete :topic, :title, :full => true, :extra_data => [:slug]

  def landing
    redirect_to codemarks_path if logged_in?
    @codemarks = FindCodemarks.new(:current_user => current_user).codemarks
  end

  def codemarklet_test
    render :layout => nil
  end

end
