class LinksController < ApplicationController

  def new
    @link = Link.new

    if params[:topic_id]
      @link.link_topics.build(:topic => Topic.find(params[:topic_id]))
    else
      @link = Link.new
    end
  end

  def create
    @link = Link.new(params[:link])
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
