class UsersController < ApplicationController
  require 'popularity'
  include OOPs

  before_filter :require_user, :only => [:dashboard, :profile]

  def profile 
    @user = current_user
  end

  def edit
    @user = current_user
  end
  
  def update
    current_user.update_attributes(params[:user])

    respond_to do |format|
      format.html { redirect_to profile_path, :notice => "Account saved" }
      format.js
    end
  end

  def dashboard
    @user = current_user

    search_attributes = {}
    search_attributes[:user] = @user if @user
    search_attributes[:page] = params[:page] if params[:page]
    search_attributes[:by] = params[:by] if params[:by]

    @codemarks = FindCodemarks.new(search_attributes).codemarks
    @topics = {}
  end

  def welcome
  end

  def show
    @user = User.find(params[:id])

    search_attributes = {}
    search_attributes[:user] = @user if @user
    search_attributes[:page] = params[:page] if params[:page]
    search_attributes[:by] = params[:by] if params[:by]

    @codemarks = FindCodemarks.new(search_attributes).codemarks
    @topics = {}

    render 'users/dashboard'
  end
end
