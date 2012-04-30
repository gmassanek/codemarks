class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    unless logged_in?
      redirect_to login_codemarklet_index_path(:url => params[:url])
      return
    end

    options = {}
    options[:url] = params[:url]
    options[:user] = current_user
    @codemark = Codemark.load(options)
  end

  def chrome_extension
    unless logged_in?
      redirect_to login_codemarklet_index_path(:url => params[:url], :chrome => '1')
      return
    end

    options = {}
    options[:url] = params[:url]
    options[:user] = current_user
    @codemark = Codemark.load(options)
    render 'new'
  end

  def login
    @callback_url = new_codemarklet_path(:url => params[:url])
    @chrome = params[:chrome] == '1'
  end
end
