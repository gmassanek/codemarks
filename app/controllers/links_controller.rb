class LinksController < ApplicationController

  def new
    @link = Link.new
    if params[:url]
      @link.url = params[:url]
      @link.fetch_title
      @possible_topics = @link.possible_topics
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @link = Link.new(params[:link])
    @link.topic_ids = params[:topic_ids]
    if @link.save
      redirect_to @link.topics.first, :notice => "Link created"
    else
      render :new
    end
  end

  def show
    @link = Link.find params[:id]
  end

end
