class TopicsController < ApplicationController

  expose(:topic)
  expose(:topics) { Topic.all }

  def new
  end

  def create
    if topic.save
      redirect_to topics_path, :notice => "Topic created"
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def show
    @topic = Topic.find params[:id]
  end

  def index
  end

  def destroy
    topic.destroy
  end

end
