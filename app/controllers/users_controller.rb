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
  end

end
