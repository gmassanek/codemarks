class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user_id, :current_user

  before_filter :identify_user

  def identify_user
    if current_user
      Analytics.identify(:user_id => current_user.slug, :traits => {
        :username => current_user.nickname,
        :name => current_user.name,
        :created => current_user.created_at
      })
    else
      Analytics.identify(:user_id => 'logged-out', :traits => {})
    end
  end

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
    @current_user ||= User.includes(:groups).find(current_user_id) if current_user_id
  end
end
