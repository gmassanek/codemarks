class PagesController < ApplicationController

  autocomplete :topic, :title, :full => true, :extra_data => [:slug]

  def landing
    if logged_in?
      #@user = current_user
      #render 'users/show' 
      flash = flash
      redirect_to current_user
    end
  end

end
