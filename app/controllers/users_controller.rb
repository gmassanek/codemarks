class UsersController < ApplicationController
  def edit
    redirect_to root_path if current_user.to_param != params[:id]
    @user = current_user
    @email_subscribed = MailchimpClient.subscribed?(@user.email)
  end
  
  def update
    if current_user.update_attributes(params[:user])
      redirect_to current_user, :notice => "Account saved"
    else
      @user = current_user
      @email_subscribed = MailchimpClient.subscribed?(@user.email)
      render :edit
    end
  end

  def show
    @user = User.find params[:id]
    @favorite_topics = @user.favorite_topics
  end

  def index
    @users = User.includes(:authentications).
      joins("LEFT JOIN (#{CodemarkRecord.select('user_id, count(*)').group(:user_id).to_sql}) cm_count ON users.id = cm_count.user_id").
      joins("LEFT JOIN (#{Click.select('user_id, count(*)').group(:user_id).to_sql}) click_count ON users.id = click_count.user_id").
      select('users.*, COALESCE(cm_count.count, 0) as cm_count, COALESCE(click_count.count, 0) as click_count')
      @users.sort_by! { |u| u.cm_count.to_i + u.click_count.to_i }.reverse!
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(50)
  end

  def subscribe
    if MailchimpClient.subscribe(params[:email])
      render :json => {:status => :ok}
    else
      render :json => {:status => :fail}
    end
  end

  def unsubscribe
    if MailchimpClient.unsubscribe(params[:email])
      render :json => {:status => :ok}
    else
      render :json => {:status => :fail}
    end
  end
end
