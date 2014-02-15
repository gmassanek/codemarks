class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    unless logged_in?
      session[:url] = params[:url]
      redirect_to login_codemarklet_index_path
      return
    end

    @topics = Topic.for_user(current_user).order(:title)

    @url = params[:url] || session[:url]
    resource = Link.for_url(@url) if @url

    Global.track(:user_id => current_user.nickname, :event => 'codemarklet_loaded', :properties => {:url => @url})
  end

  def chrome_extension
    redirect_to new_codemarklet_path(params)
  end

  def login
    @callback_url = new_codemarklet_path
  end
end
