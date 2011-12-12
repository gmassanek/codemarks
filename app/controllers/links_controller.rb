class LinksController < ApplicationController
  require 'link_saver'
  include OOPs

  def new
    @link = Link.new
    p params
    if params[:url]
      @link.url = params[:url]
      smart_link = SmartLink.new(@link.url)
      if @link.title = smart_link.title
        @pos_topics = smart_link.topics
      else
        @pos_topics = []
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @link = Link.new params[:link]
    @topics = Topic.find(params[:topic_ids].keys)
    @link = LinkSaver.save_link! @link, current_user, @topics
    redirect_to current_user, notice: "Link saved"
  rescue
    redirect_to root_path, notice: "Something when wrong"

    
  rescue Exception => ex
    puts ex.inspect

  end

  def show
    @link = Link.find params[:id]
  end

  def click
    @link = Link.find(params[:link][:id])
    Click.create(:link => @link, :user => current_user)
    respond_to do |format|
      format.js
    end
  end

  def topic_checkbox
    @topic = Topic.find params[:topic_id]
    respond_to do |format|
      format.js
    end

  end

end
