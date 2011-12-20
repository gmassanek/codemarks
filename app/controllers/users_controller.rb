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

    if params[:filter]
      session[:filter] = params[:filter]
    end
    if params[:sort]
      session[:sort] = params[:sort]
    end

    if session[:filter] == "public"
      @links = Link.scoped
      @clicks = Click.all.group_by { |click| click.link.id }
      @codemarks = Codemark.scoped

      if session[:sort] == "by_popularity"
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
      @codemarks = @codemarks.unarchived unless session[:archived]

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
    end

    @topics = {}
    puts @codemarks.inspect
    @codemarks.each do |key, value|
      puts value.inspect
      value.each do |codemark|
        puts codemark.topics.inspect
        #@topics[key] << codemark.topics
      end
    end
  end

  def welcome
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
  end
end
