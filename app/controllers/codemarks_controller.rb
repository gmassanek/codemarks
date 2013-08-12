class CodemarksController < ApplicationController
  def new
    if params[:id]
      codemark = Codemark.find_by_id(params[:id])
    else
      resource = Link.for_url(params[:url] || session[:url])
      codemark = Codemark.for_user_and_resource(current_user.try(:id), resource.try(:id))
      codemark ||= Codemark.new(:resource => resource, :user => current_user)
      codemark.topics = codemark.suggested_topics unless codemark.persisted?
    end
    render :json => PresentCodemarks.present(codemark, current_user)
  end

  def create
    attributes = params[:codemark]
    attributes[:user_id] = current_user.id
    attributes[:topic_ids] = process_topic_slugs(params['codemark']["topic_ids"])
    attributes[:resource] = Resource.create(attributes[:resource_type], params[:resource]) unless attributes[:resource_id]

    @codemark = Codemark.update_or_create(attributes)

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
      format.html
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
    @codemark = Codemark.find(params[:id])

    respond_to do |format|
      format.html do
        @user = @codemark.user
        @author = @codemark.resource.author
        Click.create(:resource => @codemark.resource, :user => current_user)
      end

      format.json do
        render :json => PresentCodemarks.present(@codemark, current_user)
      end
    end
  end

  def destroy
    @codemark = Codemark.find(params[:id])
    @codemark.destroy

    render :json => { :head => 200 }
  end

  def edit
    @codemark = Codemark.find(params[:id])
  end

  def update
    @codemark = Codemark.find(params[:id])
    params['codemark']["topic_ids"] = process_topic_slugs(params['codemark']["topic_ids"])
    success = @codemark.update_attributes(params['codemark']) && @codemark.resource.update_attributes(params['resource'])
    respond_to do |format|
      format.html do
        if success
          redirect_to codemark_path(@codemark)
        else
          flash[:error] = 'Error updating Codemark'
          render :edit
        end
      end
      format.json do
        render :json => { :codemark => PresentCodemarks.present(@codemark, current_user).to_json, :success => true }
      end
    end
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
        resource = Link.for_url(params[:url] || session[:url])
        codemark = Codemark.for_user_and_resource(current_user.try(:id), resource.try(:id))
        codemark ||= Codemark.new(:resource => resource, :user => current_user)
        codemark.topics = codemark.suggested_topics unless codemark.persisted?
        codemarks << codemark
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
