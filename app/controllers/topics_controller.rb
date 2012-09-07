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
    @topic = Topic.find params[:id]
    @user = current_user
    respond_to do |format|
      format.html do
        render 'codemarks/index', :layout => 'backbone'
      end

      format.json do
        search_attributes = {}
        search_attributes[:topic] = @topic
        search_attributes[:page] = params[:page] if params[:page]
        search_attributes[:user] = @user if @user
        search_attributes[:current_user] = current_user
        search_attributes[:by] = params[:by] if params[:by]
        @codemarks = FindCodemarks.new(search_attributes).try(:codemarks)
        render :json => PresentCodemarks.for(@codemarks, current_user)
      end
    end
  end

  def index
    @topics = Topic.all
  end

  def destroy
    @topic = Topic.find params[:id]
  end
end
