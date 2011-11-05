class TopicsController < ApplicationController

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new params[:topic]
    if @topic.save
      redirect_to topics_path, :notice => "Topic created"
    else
      render :new
    end
  end

  def edit
    @topic = Topic.find params[:id]
    missing_sponsored_sites = SponsoredSite::SponsoredSites.constant_values - @topic.sponsored_sites.collect(&:site)
    missing_sponsored_sites.each do |site|
      @topic.sponsored_sites.build(:site => site)
    end
  end

  def update
    @topic = Topic.find params[:id]
    if @topic.update_attributes params[:topic]
      redirect_to topics_path, :notice => "Topic updated"
    else
      render :edit
    end
  end

  def show
    @topic = Topic.find params[:id]
  end

  def index
    @topics = Topic.all
  end

  def destroy
    @topic = Topic.find params[:id]
  end

end
