require 'incoming_email_parser'
include OOPs

class ListenerController < ApplicationController
  def sendgrid
    logger.info params.inspect
    logger.debug params.inspect
    IncomingEmailParser.parse(params)
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def bookmarklet
    @user = User.find_by_id(params[:id])
    puts @user.inspect
    logger.info @user.inspect
    if @user
      url = params[:l]

      @success = IncomingEmailParser.save_bookmarklet(@user, url).present?
      puts @success.inspect
      respond_to do |format|
        format.js
      end
    else
      render :nothing => true
    end
  end
end
