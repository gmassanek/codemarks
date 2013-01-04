class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    unless logged_in?
      redirect_to login_codemarklet_index_path(:url => params[:url])
      return
    end

    @topics = Topic.all

    options = {}
    options[:url] = params[:url]
    options[:user_id] = current_user.id if current_user
    codemark = Codemark.load(options)
    @codemark = PresentCodemarks.present(codemark, current_user)
  end

  def chrome_extension
    redirect_to new_codemarklet_path(params)
  end

  def login
    @callback_url = new_codemarklet_path(:url => params[:url])
    @chrome = params[:chrome] == '1'
  end
end
