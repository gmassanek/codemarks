class UsersController < ApplicationController
  require 'popularity'
  include OOPs

  before_filter :require_user, :only => [:dashboard]

  def profile 
    @user = current_user
  end
  
  def update
    current_user.update_attribute(:email, params[:user][:email])
    redirect_to profile_path, :notice => "Email saved"
  end

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
      @codemarks = Codemark.scoped

      if params[:sort] == "by_popularity"
        @codemarks = @codemarks.group_by { |ls| ls.link.id }
        @links = @links.sort_by { |link| 
           LinkPopularity.calculate_scoped(link, @clicks, @codemarks)
        }
        @links.reverse!
      else
        @codemarks = @codemarks.by_save_date
        link_ids = @codemarks.collect(&:link_id)
        @links = @links.sort do |a, b|
          link_ids.index(a.id) <=> link_ids.index(b.id)
        end
        @codemarks = @codemarks.group_by { |ls| ls.link.id }
      end




    else
      @clicks = @user.clicks.group_by { |click| click.link.id }
      @codemarks = @user.codemarks
      @codemarks = @codemarks.unarchived unless params[:archived]


      if params[:sort] == "by_popularity"
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

    end

#    #

#    if params[:sort] == "by_popularity"
#      @links = @links.sort_by { |link| LinkPopularity.calculate link }
#    else
      #@codemarks = @codemarks.sort_by { |ls| ls.created_at }
      #@links = @links.sort do |a, b| 
      #  @codemarks[a.id].first.created_at <=> @codemarks[b.id].first.created_at
      #end
#    end
  end

  def show
    @user = User.find(params[:id])
    @codemarks = @user.codemarks
    @codemarks = @codemarks.unarchived unless params[:archived]

    if params[:by_popularity]
      @codemarks = @codemarks.by_popularity 
    else
      @codemarks = @codemarks.by_save_date
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
