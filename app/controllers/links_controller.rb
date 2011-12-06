class LinksController < ApplicationController
  require 'link_saver'

  def new
    @link = Link.new
    p params
    if params[:url]
      @link.url = params[:url]
      if @link.fetch_title
        @possible_topics = @link.possible_topics
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @link = ResourceManager::LinkSaver.create_link params[:link], params[:topic_ids], params[:reminder], current_user_id
    if @link
      redirect_to @link.topics.first, :notice => "Link created"
    else
      render :new
    end
  end

  def show
    @link = Link.find params[:id]
  end

  def click
    @link = Link.find(params[:link][:id])
    Click.create(:link => @link, :user => current_user)
    raise "click created"
    respond_to do |format|
      format.js
    end
  end

end
