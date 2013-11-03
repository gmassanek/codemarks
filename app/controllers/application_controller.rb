class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user_id, :current_user

  def require_user
    redirect_to root_path unless logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def current_user_id
    cookies.signed[:remember_token]
  end

  def current_user
    @current_user ||= User.find current_user_id if current_user_id
  end
end
