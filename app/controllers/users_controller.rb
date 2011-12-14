class UsersController < ApplicationController
  require 'popularity'
  include OOPs

  before_filter :require_user, :only => [:dashboard]

  def create
    @user = User.new params[:user]
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def dashboard
    @user = current_user

    if params[:filter] == "public"
      @links = Link.scoped
      @clicks = Click.all.group_by { |click| click.link.id }
      @link_saves = LinkSave.scoped



      if params[:sort] == "by_popularity"
        @link_saves = @link_saves.group_by { |ls| ls.link.id }
        @links = @links.sort_by { |link| 
           LinkPopularity.calculate_scoped(link, @clicks, @link_saves)
        }
      else
        @link_saves = @link_saves.by_save_date
        link_ids = @link_saves.collect(&:link_id)
        @links = @links.sort do |a, b|
          link_ids.index(a.id) <=> link_ids.index(b.id)
        end
        @link_saves = @link_saves.group_by { |ls| ls.link.id }
      end




    else
      @clicks = @user.clicks.group_by { |click| click.link.id }
      @link_saves = @user.link_saves
      @link_saves = @link_saves.unarchived unless params[:archived]


      if params[:sort] == "by_popularity"
        link_ids = @link_saves.collect(&:link_id)
        @link_saves = @link_saves.group_by { |ls| ls.link.id }
        @links = Link.find(link_ids)
        @links = @links.sort_by { |link| 
           LinkPopularity.calculate_scoped(link, @clicks, @link_saves)
        }
      else
        @link_saves = @link_saves.by_save_date
        link_ids = @link_saves.collect(&:link_id)
        @links = Link.find(link_ids)
        @links = @links.sort do |a, b|
          link_ids.index(a.id) <=> link_ids.index(b.id)
        end
        @link_saves = @link_saves.group_by { |ls| ls.link.id }
      end

    end

#    #

#    if params[:sort] == "by_popularity"
#      @links = @links.sort_by { |link| LinkPopularity.calculate link }
#    else
      #@link_saves = @link_saves.sort_by { |ls| ls.created_at }
      #@links = @links.sort do |a, b| 
      #  @link_saves[a.id].first.created_at <=> @link_saves[b.id].first.created_at
      #end
#    end
  end

  def show
    @user = User.find(params[:id])
    @link_saves = @user.link_saves
    @link_saves = @link_saves.unarchived unless params[:archived]

    if params[:by_popularity]
      @link_saves = @link_saves.by_popularity 
    else
      @link_saves = @link_saves.by_save_date
    end
    #@links = 
    #if params[:filter] == "all"
    #  @reminders = current_user.reminders
    #else
    #  @reminders = current_user.reminders.unfinished
    #end

    #if params[:sort] == "recent_activity"
    #  @reminders = @reminders.by_date
    #else
    #  params[:sort] = 'popularity'
    #  @reminders = @reminders.by_popularity
    #end
  end

end
