class SessionsController < ApplicationController

  def create
    @user = User.find_by_email params[:user][:email]
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to @user, :notice => "Signed in successfully"
    else
      flash[:notice] = "Incorrect sign in credentials.  Try again"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Logged out successfully"
  end

  def filter
    session[:filter] = params[:filter]
    redirect_to :back
  end

end
