require 'authenticator'
class SessionsController < ApplicationController
  include OOPs

  def create
    if current_user
      @user = current_user
      Authenticator.add_authentication_to_user @user, params[:provider], auth_hash
    else
      @user = Authenticator.find_or_create_user_from_auth_hash params[:provider], auth_hash
    end

    session[:user_id] = @user.id
    redirect_to dashboard_path, :notice => "Signed in successfully"
  rescue Exception => ex
    logger.info ex.to_s
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

  def auth_hash
    request.env['omniauth.auth']
  end

end
