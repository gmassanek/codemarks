class LinksController < ApplicationController
  def new
    @link = Link.new
    if params[:url]
      @link.url = params[:url]
      begin
        smart_link = Codemarks::Link.new(@link.url)
        if smart_link.response
          @link.title = smart_link.title
          @link.host = smart_link.host
          @pos_topics = smart_link.topics
        else
          @pos_topics = []
        end
      rescue Exception => ex
        p "Exception in app/controllers/links_controller.rb boooo"
        @link.errors.add(:url, "is invalid")
        @pos_topics = []
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @link = Link.new params[:link]
    @topics = Topic.find(params[:topic_ids].keys)
    @link = LinkSaver.save_link! @link, current_user, @topics
    redirect_to dashboard_path, notice: "Link saved"
  rescue
    redirect_to :back, notice: "Something when wrong"

    
  rescue Exception => ex
    puts ex.inspect

  end

  def show
    @link = Link.find params[:id]
  end

  def click
    @link = LinkRecord.find(params[:id])
    Click.create(:link_record => @link, :user => current_user)
    render :nothing => true, :status => :ok
  end
end
