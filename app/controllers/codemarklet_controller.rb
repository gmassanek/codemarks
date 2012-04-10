class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    unless logged_in?
      redirect_to login_codemarklet_index_path(:url => params[:url])
    end

    options = {}
    options[:url] = params[:url]
    @codemark = Codemark.load(options)
  end

  def login
    @callback_url = new_codemarklet_path(:url => params[:url])
  end
end
