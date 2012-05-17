class CodemarksController < ApplicationController

  def new
    options = {}
    options[:url] = params[:url]
    options[:id] = params[:id] if params[:id]
    options[:user_id] = current_user.id if current_user
    @codemark = Codemark.load(options)
  end

  def create
    topic_ids = params[:tags].keys.collect(&:to_i) if params[:tags]
    topic_ids ||= []

    new_topic_titles = params[:topic_ids].keys if params[:topic_ids] 

    @codemark = Codemark.create(params[:codemark_attrs], 
                                params[:resource_attrs], 
                                topic_ids, 
                                current_user, 
                                :new_topic_titles => new_topic_titles)

    respond_to do |format|
      format.html { redirect_to :back, :notice => 'Thanks!' }
      format.js { render :text => '', :status => :ok }
    end
  end

  def public
    search_attributes = {}
    search_attributes[:page] = params[:page] if params[:page]
    search_attributes[:by] = params[:by] if params[:by]
    @codemarks = FindCodemarks.new(search_attributes).codemarks

    render 'users/dashboard'
  end

  def search
    @codemarks = FindCodemarks.new(:search_term => params[:search]).codemarks
    render 'users/dashboard'
  end

  def destroy
    @codemark = CodemarkRecord.find(params[:id])
    @codemark.destroy

    render :json => { :head => 200 }
  end

  def topic_checkbox
    @topic = Topic.find_by_slug params[:topic_id]
    @topic_title = params[:topic_title]
    respond_to do |format|
      if @topic_title.present?
        format.js { render :new_topic_checkbox }
      else
        format.js { render :topic_checkbox }
      end
    end
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
  end

end
