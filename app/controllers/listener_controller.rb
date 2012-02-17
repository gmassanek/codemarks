require 'codemarks/codemark'
include Codemarks

class ListenerController < ApplicationController
  def prepare_bookmarklet
    @cm = Codemark.prepare(:link, {:url => params[:l]})
    @user_id = params[:id]
  end

  def bookmarklet
    @user = User.find_by_id(params[:id])
    if @user
      url = params[:l]

      @success = IncomingEmailParser.save_bookmarklet(@user, url).present?
      respond_to do |format|
        format.js
      end
    else
      render :nothing => true
    end
  end

  def sendgrid
    logger.info params.inspect
    logger.debug params.inspect
    IncomingEmailParser.parse(params)
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
