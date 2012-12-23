class UsersController < ApplicationController
  before_filter :require_user, :only => [:dashboard, :account]

  def account
    redirect_to root_path if current_user.to_param != params[:id]
    @user = current_user
  end

  def edit
    redirect_to root_path if current_user.to_param != params[:id]
    @user = current_user
  end
  
  def update
    current_user.update_attributes(params[:user])

    respond_to do |format|
      format.html { redirect_to account_path(current_user), :notice => "Account saved" }
      format.js
    end
  end

  def welcome
  end

  def show
    redirect_to codemarks_path(:user => params[:username])
  end
end
