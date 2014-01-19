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
    cookies[:'server-set'] = true
    redirect_to codemarks_path(:topic_ids => params[:id], :by => 'popularity')
  end

  def index
    @topics = Topic.order(:title)
    respond_to do |format|
      format.json do
        response = Rails.cache.fetch('topics-json', :expires_in => 10) do
          PresentTopics.for(@topics)
        end
        render :json => response
      end

      format.html do
        @topics = @topics.joins("LEFT JOIN (#{CodemarkTopic.select('topic_id, count(*)').group(:topic_id).to_sql}) cm_count ON topics.id = cm_count.topic_id").select('topics.*, COALESCE(cm_count.count, 0) as cm_count')
        @topics.shuffle!
        @max = @topics.max_by { |t| t.cm_count.to_i }.cm_count.to_f
      end
    end
  end

  def destroy
    @topic = Topic.find params[:id]
  end
end
