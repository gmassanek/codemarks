class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user_id, :current_user, :filter_by_mine?

  before_filter :build_new_codemark

  def build_new_codemark
    @new_codemark = Codemark.new
  end

  def logged_in?
    current_user_id.present?
  end

  def current_user_id
    session[:user_id]
  end

  def current_user
    User.find current_user_id if logged_in?
  end

  def filter_by_mine?
    session[:filter] == 'mine'
  end

  def require_user
    redirect_to root_path unless logged_in?
  end

end
