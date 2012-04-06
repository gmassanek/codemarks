class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    options = {}
    options[:url] = params[:url]
    @codemark = Codemark.load(options)
  end
end
