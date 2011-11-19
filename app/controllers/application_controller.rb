class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    session[:user_id].present?
  end

  def current_user_id
    session[:user_id]
  end

  def current_user
    User.find current_user_id if logged_in?
  end

end
