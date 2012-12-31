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

  def welcome
  end

  def show
    @user = User.find params[:id]
    @favorite_topics = @user.favorite_topics
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
