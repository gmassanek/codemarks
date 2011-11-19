class SessionsController < ApplicationController

  def create
    @user = User.find_by_email params[:user][:email]
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Signed in successfully"
    else
      flash[:notice] = "Incorrect sign in credentials.  Try again"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Logged out successfully"
  end

end
