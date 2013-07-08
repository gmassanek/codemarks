class CodemarksController < ApplicationController
  def new
    options = {}
    options[:url] = params[:url]
    options[:id] = params[:id] if params[:id]
    options[:user_id] = current_user.id if current_user
    @codemark = Codemark.load(options)
    render :json => PresentCodemarks.present(@codemark, current_user)
  end

  def create
    attributes = params[:codemark]
    attributes[:user_id] = current_user.id
    attributes[:topic_ids] = process_topic_slugs(params['codemark']["topic_ids"])

    @codemark = CodemarkRecord.update_or_create(attributes)

    render :json => {
      :codemark => PresentCodemarks.present(@codemark, current_user).to_json,
      :success => true
    }
  rescue Exception => e
    p e
    puts e.backtrace.first(10).join("\n")
  end

  def index
    @user = User.find_by_slug(params[:user]) || User.find_by_id(params[:user])

    if params[:topic_ids]
      @topic_ids = Topic.where(:slug => params[:topic_ids].split(',')).pluck(:id)
    end

    respond_to do |format|
      format.html do
        render 'codemarks/index'
      end

      format.json do
        search_attributes = {
          :page => params[:page],
          :by => params[:by],
          :current_user => current_user,
          :user => @user,
          :topic_ids => @topic_ids,
          :search_term => params[:query]
        }
        @codemarks = FindCodemarks.new(search_attributes).try(:codemarks)
        render :json => PresentCodemarks.for(@codemarks, current_user, @user)
      end
    end
  end

  def show
    codemark = CodemarkRecord.find(params[:id])
    render :json => PresentCodemarks.present(codemark, current_user)
  end

  def destroy
    @codemark = CodemarkRecord.find(params[:id])
    @codemark.destroy

    render :json => { :head => 200 }
  end

  def update
    params['codemark']["topic_ids"] = process_topic_slugs(params['codemark']["topic_ids"])
    @codemark = CodemarkRecord.find(params[:id])
    @codemark.update_attributes(params['codemark'])
    render :json => {
      :codemark => PresentCodemarks.present(@codemark, current_user).to_json,
      :success => true
    }
  end

  def github
    payload = params[:payload]
    payload = JSON.parse(payload)
    user_name = payload["pusher"]["name"]
    user = User.find_by_authentication("github", user_name)

    codemarks = []
    payload["commits"].each do |commit|
      message = commit["message"]
      if message.include?("#cm")
        url = commit["url"]
        codemarks << Codemark.new(:link, {:url => url})
      end
    end
  end

  private

  def process_topic_slugs(topic_slugs)
    return [] unless topic_slugs.present?
    topics = topic_slugs.split(',').map { |slug| Topic.find_by_slug(slug) || slug }
    topics, new_titles = topics.partition { |item| item.is_a? Topic }
    new_topics = new_titles.map { |title| Topic.create!(:title => title) }
    (topics | new_topics).map(&:id)
  end
end
