class SessionsController < ApplicationController
  def new
    redirect_to codemarks_path if logged_in?
  end

  def failure
    Rails.logger.error "======================== Failed auth =========================="
    Rails.logger.error params.inspect
  end

  def create
    if current_user
      @user = current_user
      Authenticator.add_authentication_to_user @user, params[:provider], auth_hash
      flash[:notice] = "Successfully authenticated"
    else
      @user = Authenticator.find_or_create_user_from_auth_hash params[:provider], auth_hash
      cookies.permanent.signed[:remember_token] = @user.id
      flash[:notice] = "Signed in"
    end

    if session[:callback]
      redirect_to session[:callback]
      return
    end

    if FindCodemarks.new(:user => @user, :current_user => current_user).codemarks.count == 0
      @link = Link.new
      redirect_to welcome_path
    else
      redirect_to short_user_path(@user)
    end

  rescue Exception => ex
    p "Exception in app/controllers/sessions_controller.rb A"
    logger.info ex.to_s
    puts ex.to_s
    puts ex.backtrace
    redirect_to root_path, :notice => "Sorry, something went wrong"
  end

  def destroy
    @current_user = nil
    reset_session
    cookies[:remember_token] = {:expires => 1.day.ago.utc}
    redirect_to root_path, :notice => "Logged out successfully"
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def codemarklet
    callback_url = params[:callback]
    session[:callback] = callback_url if callback_url

    redirect_to "/auth/#{params[:provider]}"
  end
end
