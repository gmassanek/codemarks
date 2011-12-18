require 'incoming_email_parser'
include OOPs

class ListenerController < ApplicationController
  def sendgrid
    logger.info params.inspect
    logger.debug params.inspect
    IncomingEmailParser.parse(params)
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
