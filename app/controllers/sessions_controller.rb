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
      redirect_to edit_user_path(@user)
    else
      @user = Authenticator.find_or_create_user_from_auth_hash params[:provider], auth_hash
      cookies.permanent.signed[:remember_token] = @user.id

      if session[:callback]
        redirect_to session[:callback]
        return
      end

      if @user.created_at > 5.minutes.ago
        flash[:info] = "Welcome! Update your profile, then find out more about <a href=#{about_path}>How Codemarks Works</a>"
        redirect_to edit_user_path(@user)
      else
        flash[:notice] = 'Signed in'
        redirect_to :back
      end
    end

  rescue ActiveRecord::RecordInvalid => ex
    p "Error saving user"
    logger.info ex.to_s
    puts ex.to_s
    flash[:error] = "The username has been taken. Please sign in with your other account"
    redirect_to root_path

  rescue Exception => ex
    p "Exception in app/controllers/sessions_controller.rb A"
    logger.info ex.to_s
    puts ex.to_s
    flash[:error] = "Sorry, something went wrong"
    redirect_to root_path
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
