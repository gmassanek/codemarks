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
    current_user.update_attribute(:email, params[:user][:email])
    redirect_to profile_path, :notice => "Email saved"
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

    @topics = {}
    @codemarks.each do |key, value|
      @topics[key] = Array(*value.collect(&:topics)) 
    end
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
