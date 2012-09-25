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
    cookies[:filters] = {:topics => [params[:id]]}.to_json
    cookies[:'server-set'] = true
    redirect_to codemarks_path
  end

  def index
    @topics = Topic.all
  end

  def destroy
    @topic = Topic.find params[:id]
  end
end
