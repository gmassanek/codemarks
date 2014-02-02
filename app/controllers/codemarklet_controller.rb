class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    unless logged_in?
      session[:url] = params[:url]
      redirect_to login_codemarklet_index_path
      return
    end

    @topics = Topic.for_user(current_user).order(:title)

    resource = Link.for_url(params[:url] || session[:url])
    codemark = Codemark.for_user_and_resource(current_user.try(:id), resource.try(:id))
    codemark ||= Codemark.new(:resource => resource, :user => current_user)
    codemark.topics = codemark.suggested_topics unless codemark.persisted?

    Global.track(:user_id => current_user.nickname, :event => 'codemarklet_loaded', :properties => codemark.tracking_data)
    @codemark = PresentCodemarks.present(codemark, current_user)
  end

  def chrome_extension
    redirect_to new_codemarklet_path(params)
  end

  def login
    @callback_url = new_codemarklet_path
  end
end
