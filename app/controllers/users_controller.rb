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
    @user = User.find_by_slug(params[:id])
    @user ||= User.find_by_id(params[:id])

    search_attributes = {}
    search_attributes[:user] = @user if @user
    search_attributes[:page] = params[:page] if params[:page]
    search_attributes[:by] = params[:by] if params[:by]

    @codemarks = FindCodemarks.new(search_attributes).codemarks
    @topics = {}

    render 'users/dashboard'
  end
end
