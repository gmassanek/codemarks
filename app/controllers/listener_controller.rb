class ListenerController < ApplicationController
  def prepare_bookmarklet
    @codemark = Codemark.new(:link, {:url => params[:l]})
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
    email = JSON.parse(params["envelope"])["from"]
    user = User.find_by_email(email)

    if user
      urls = ListenerParamsParser.extract_urls_from_body(params["text"])
      urls.each do |url|
        Codemark.build_and_create(user, :link, {:url => url})
      end
    end

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def github
    payload = params[:payload]
    payload = JSON.parse(payload)
    user_name = payload["pusher"]["name"]
    user = User.find_by_authentication("github", user_name)

    codemarks = []
    payload["commits"].each do |commit|
      message = commit["message"]
      if message.include?("#cm")
        url = commit["url"]
        codemarks << Codemark.new(:link, {:url => url})
      end
    end

    codemarks.each do |cm|
      Codemark.create({},
                      cm.resource.resource_attrs,
                      cm.topics.collect(&:id),
                      user)
    end

    respond_to do |format|
      format.html { head :ok }
    end
  end

  private

end
