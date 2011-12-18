require 'authenticator'
class SessionsController < ApplicationController
  include OOPs

  def create
    if current_user
      @user = current_user
      before_cnt = @user.authentications.count
      Authenticator.add_authentication_to_user @user, params[:provider], auth_hash
      flash[:notice] = "Successfully authentication"
    else
      @user = Authenticator.find_or_create_user_from_auth_hash params[:provider], auth_hash
      session[:user_id] = @user.id
      if @user.email.blank? || @user.missing_authentications.present?
        if @user.email.blank? && @user.missing_authentications.present?
          puts "1"
          flash[:notice] = "Complete your #{link_to 'profile', profile_path}. You are missing your email and #{@user.missing_authentications} authentications"
        elsif @user.email.blank?
          puts "2"
          flash[:notice] = "Complete your #{link_to 'profile', profile_path}. You are missing your email"
        else
          puts "3"
          flash[:notice] = "Complete your #{link_to 'profile', profile_path}. You are missing your #{@user.missing_authentications} authentications"
        end
      end
    end
    redirect_to dashboard_path

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
