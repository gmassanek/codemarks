class UsersController < ApplicationController

  def create
    @user = User.new params[:user]
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = current_user
    if params[:filter] == "all"
      @reminders = current_user.reminders
    else
      @reminders = current_user.reminders.unfinished
    end

    if params[:sort] == "recent_activity"
      @reminders = @reminders.by_date
    else
      params[:sort] = 'popularity'
      @reminders = @reminders.by_popularity
    end
  end

end
