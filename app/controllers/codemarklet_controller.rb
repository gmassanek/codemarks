class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    redirect_to login_codemarklet_index_path unless logged_in?
    options = {}
    options[:url] = params[:url]
    @codemark = Codemark.load(options)
  end

  def login
    p "woooo"
  end
end
