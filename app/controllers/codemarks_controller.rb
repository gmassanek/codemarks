class CodemarksController < ApplicationController
  def new
    options = {}
    options[:url] = params[:url]
    options[:id] = params[:id] if params[:id]
    options[:user_id] = current_user.id if current_user
    @codemark = Codemark.load(options)
    render :json => PresentCodemarks.present(@codemark, current_user)
  end

  def create
    topic_ids = params[:codemark].delete("topic_ids")
    attributes = params[:codemark]
    attributes[:user_id] = current_user_id

    topic_info = {
      :ids => topic_ids,
      :new_topics => params[:new_topics].try(:keys)
    }

    @codemark = Codemark.create(attributes, topic_info)

    render :json => {
      :codemark => PresentCodemarks.present(@codemark, current_user).to_json,
      :success => true
    }
  rescue Exception => e
    p e
    puts e.backtrace.first(10).join("\n")
  end

  def index
    @user = User.find_by_slug(params[:user]) || User.find_by_id(params[:user])

    @topic = Topic.find(params[:topic_id]) if params[:topic_id]
    respond_to do |format|
      format.html do
        render 'codemarks/index', :layout => 'backbone'
      end

      format.json do
        search_attributes = {}
        search_attributes[:page] = params[:page] if params[:page]
        search_attributes[:by] = params[:by] if params[:by]
        search_attributes[:current_user] = current_user
        search_attributes[:user] = @user if @user
        search_attributes[:topic_id] = params[:topic_id] if params[:topic_id]
        @codemarks = FindCodemarks.new(search_attributes).try(:codemarks)
        render :json => PresentCodemarks.for(@codemarks, current_user)
      end
    end
  end

  def search
    @codemarks = FindCodemarks.new(:search_term => params[:query], :current_user => current_user).codemarks
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

  def update
    @codemark = CodemarkRecord.find(params[:id])
    @codemark.update_attributes(params['codemark'])
    render :json => {
      :codemark => PresentCodemarks.present(@codemark, current_user).to_json,
      :success => true
    }
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
