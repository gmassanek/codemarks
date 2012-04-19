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
      redirect_to @topic, :notice => "Topic updated"
    else
      render :edit
    end
  end

  def show
    if params[:user_id].present?
      @user = User.find_by_slug(params[:user_id])
      @user ||= User.find_by_id(params[:user_id])
    end

    @topic = Topic.find params[:id]

    search_attributes = {}
    search_attributes[:topic] = @topic
    search_attributes[:page] = params[:page] if params[:page]
    search_attributes[:user] = @user if @user
    search_attributes[:by] = params[:by] if params[:by]

    @codemarks = FindCodemarks.new(search_attributes).codemarks
  end

  def index
    @topics = Topic.all
  end

  def destroy
    @topic = Topic.find params[:id]
  end
end
