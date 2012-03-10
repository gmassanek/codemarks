class ListenerController < ApplicationController
  def prepare_bookmarklet
    @codemark = Codemark.prepare(:link, {:url => params[:l]})
    @user_id = params[:id]

    respond_to do |format|
      format.js
    end
  end

  def bookmarklet
    topic_ids = params[:tags].keys.collect(&:to_i) if params[:tags]
    topic_ids ||= []

    new_topic_titles = params[:topic_ids].keys if params[:topic_ids] 

    user = User.find(params["user_id"])

    @codemark = Codemark.create(params[:codemark_attrs], 
                                params[:resource_attrs], 
                                topic_ids, 
                                user,
                                :new_topic_titles => new_topic_titles)

    respond_to do |format|
      format.json { head :ok }
    end
  end

  def sendgrid
    logger.info params.inspect
    logger.debug params.inspect
    IncomingEmailParser.parse(params)
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def github
    p "Hello!!"
    p params["payload"]["commits"]


    respond_to do |format|
      format.html { head :ok }
    end
  end
end
