class TopicsController < ApplicationController

  def new
    @topic = Topic.new
    build_missing_sponsored_sites
  end

  def create
    @topic = Topic.new params[:topic]
    if @topic.save
      redirect_to topics_path, :notice => "Topic created"
    else
      build_missing_sponsored_sites
      render :new
    end
  end

  def edit
    @topic = Topic.find params[:id]
    build_missing_sponsored_sites
  end

  def update
    @topic = Topic.find params[:id]
    if @topic.update_attributes params[:topic]
      redirect_to topics_path, :notice => "Topic updated"
    else
      build_missing_sponsored_sites
      render :edit
    end
  end

  def show
    @topic = Topic.find params[:id]
    @resources = []
    #@topic.links.each { |l| @resources << l unless l.nil? }

    if params[:sort] == "save_count"
      puts "hello 1"
      @resources = @topic.links.by_saves
    elsif params[:order] == "clicks"
      puts "hello 2"
      @resources = @topic.links.by_clicks
    else
      @resources = @topic.links
    end
  end

  def index
    @topics = Topic.all

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @topic = Topic.find params[:id]
  end

  private

  def build_missing_sponsored_sites
    missing_sponsored_sites = SponsoredSite::SponsoredSites.constant_values - @topic.sponsored_sites.collect(&:site)
    missing_sponsored_sites.each do |site|
      @topic.sponsored_sites.build(:site => site)
    end
  end
end
