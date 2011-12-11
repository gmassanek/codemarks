class PagesController < ApplicationController

  autocomplete :topic, :title, :full => true, :extra_data => [:slug]

  def landing
    redirect_to current_user if logged_in?
  end

end
