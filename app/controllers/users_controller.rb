class UsersController < ApplicationController
  require 'popularity'
  include OOPs

  before_filter :require_user, :only => [:dashboard, :profile]

  def profile 
    @user = current_user
  end

  def edit
    @user = current_user
  end
  
  def update
    current_user.update_attributes(params[:user])

    respond_to do |format|
      format.html { redirect_to profile_path, :notice => "Account saved" }
      format.js
    end
  end

  def dashboard
    @user = current_user

    @codemarks = []
    @links = []

    #if params[:filter]
    #  session[:filter] = params[:filter]
    #end
    #if params[:sort]
    #  session[:sort] = params[:sort]
    #end

    #if session[:filter] == "public"
    #  @links = Link.scoped
    #  @clicks = Click.all.group_by { |click| click.link.id }
    #  @codemarks = Codemark.scoped

    #  if session[:sort] == "by_popularity"
    #    @codemarks = @codemarks.group_by { |ls| ls.link.id }
    #    @links = @links.sort_by { |link| 
    #       LinkPopularity.calculate_scoped(link, @clicks, @codemarks)
    #    }
    #    @links.reverse!
    #  else
    #    @codemarks = @codemarks.by_save_date
    #    link_ids = @codemarks.collect(&:link_id)
    #    @links = @links.sort do |a, b|
    #      link_ids.index(a.id) <=> link_ids.index(b.id)
    #    end
    #    @codemarks = @codemarks.group_by { |ls| ls.link.id }
    #  end
    #else
    #  @clicks = []
    #  @codemarks = @user.codemark_records
    #  @codemarks = @codemarks.unarchived unless session[:archived]

    #  if session[:sort] == "by_popularity"
    #    link_ids = @codemarks.collect(&:link_id)
    #    @codemarks = @codemarks.group_by { |ls| ls.link.id }
    #    @links = Link.find(link_ids)
    #    @links = @links.sort_by { |link| 
    #       LinkPopularity.calculate_scoped(link, @clicks, @codemarks)
    #    }
    #    @links.reverse!
    #  else
    #    @codemarks = @codemarks.by_save_date
    #    link_ids = @codemarks.collect(&:link_id)
    #    @links = LinkRecord.find(link_ids)
    #    @links = @links.sort do |a, b|
    #      link_ids.index(a.id) <=> link_ids.index(b.id)
    #    end
    #    @codemarks = @codemarks.group_by { |cm| cm.link_record.id if cm.link_record}
    #  end
    #end

    @topics = {}
    @codemarks.each do |link_id, codemarks|
      @topics[link_id] = []
      codemarks.each do |codemark|
        codemark.topics.each do |topic|
          @topics[link_id] << topic
        end
      end
    end
  end

  def welcome
  end

  def show
    @user = User.find(params[:id])

    if params[:filter]
      session[:filter] = params[:filter]
    end
    if params[:sort]
      session[:sort] = params[:sort]
    end

    @clicks = @user.clicks.group_by { |click| click.link.id }
    @codemarks = @user.codemarks

    if session[:sort] == "by_popularity"
      link_ids = @codemarks.collect(&:link_id)
      @codemarks = @codemarks.group_by { |ls| ls.link.id }
      @links = Link.find(link_ids)
      @links = @links.sort_by { |link| 
         LinkPopularity.calculate_scoped(link, @clicks, @codemarks)
      }
      @links.reverse!
    else
      @codemarks = @codemarks.by_save_date
      link_ids = @codemarks.collect(&:link_id)
      @links = Link.find(link_ids)
      @links = @links.sort do |a, b|
        link_ids.index(a.id) <=> link_ids.index(b.id)
      end
      @codemarks = @codemarks.group_by { |ls| ls.link.id }
    end

    @topics = {}
    @codemarks.each do |link_id, codemarks|
      @topics[link_id] = []
      codemarks.each do |codemark|
        codemark.topics.each do |topic|
          @topics[link_id] << topic
        end
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
