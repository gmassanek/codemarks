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
    #@resources = @topic.links.scoped

    #if !logged_in?
    #  @resources = @resources.all_public
    #elsif filter_by_mine?
    #  @resources = @resources.for_user(current_user)
    #else
    #  @resources = @resources.public_and_for_user(current_user)
    #end

    #if params[:sort] == "recent_activity"
    #  @resources = @resources.by_create_date
    #else
    #  params[:sort] = 'popularity'
    #  @resources = @resources.by_popularity
    #end

    #@resources = @resources.page params[:pg]
    @resources = []
    @topics = {}

    respond_to do |format|
      format.html
      format.js
    end
  end

  def index

      @topics = Topic.all
    #if !logged_in?
    #  @topics = Topic.all
    #elsif filter_by_mine?
    #  @topics = Topic.for_user(current_user)
    #else
    #  @topics = current_user.topics
    #end

    #sort_order = params[:sort]
    #if sort_order == 'resource_count'
    #  @topics = @topics.by_resource_count
    #elsif sort_order == 'recent_activity'
    #  @topics = @topics.by_recent_activity
    #else 
    #  params[:sort] = 'popularity'
    #  @topics = @topics.by_popularity
    #end

    #@topics = @topics.page params[:pg]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @topic = Topic.find params[:id]
  end
end
