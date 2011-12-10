require 'authenticator'
class SessionsController < ApplicationController
  #include OOPs

  def create
    if current_user
      @user = current_user
      OOPs::Authenticator.add_authentication_to_user @user, params[:provider], request.env['omniauth.auth']
    else
      @user = OOPs::Authenticator.find_or_create_user_from_auth_hash params[:provider], request.env['omniauth.auth']
    end

    session[:user_id] = @user.id
    redirect_to @user, :notice => "Signed in successfully"
  rescue Exception => ex
    logger.log ex.to_s
    puts ex.to_s
    redirect_to root_path, :notice => "Sorry, something went wrong"
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
