class ListenerController < ApplicationController
  def sendgrid
    puts params.inspect
    puts "incoming params"
    logger.info params.inspect
    logger.debug params.inspect
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
