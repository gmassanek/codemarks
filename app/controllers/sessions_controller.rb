class SessionsController < ApplicationController
  def create
    if current_user
      @user = current_user
      Authenticator.add_authentication_to_user @user, params[:provider], auth_hash
      flash[:notice] = "Successfully authentication"
    else
      @user = Authenticator.find_or_create_user_from_auth_hash params[:provider], auth_hash
      cookies.permanent.signed[:remember_token] = @user.id
      flash[:notice] = "Signed in"
    end
    session[:filter] = "mine"
    session[:sort] = "by_save_date"

    if FindCodemarks.new(:user => @user).codemarks.count == 0
      @link = Link.new
      redirect_to welcome_path
    else
      redirect_to dashboard_path
    end

  rescue Exception => ex
    p "Exception in app/controllers/sessions_controller.rb A"
    logger.info ex.to_s
    puts ex.to_s
    redirect_to root_path, :notice => "Sorry, something went wrong"
  end

  def destroy
    reset_session
    cookies[:remember_token] = {:expires => 1.day.ago.utc}
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
