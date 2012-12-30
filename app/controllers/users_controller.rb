class UsersController < ApplicationController
  def edit
    redirect_to root_path if current_user.to_param != params[:id]
    @user = current_user
  end
  
  def update
    current_user.update_attributes(params[:user])

    respond_to do |format|
      format.html { redirect_to current_user, :notice => "Account saved" }
      format.js
    end
  end

  def welcome
  end

  def show
    @user = User.find params[:id]
    @favorite_topics = @user.favorite_topics
  end
end
