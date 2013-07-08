class CodemarkletController < ApplicationController
  layout 'codemarklet'

  def new
    unless logged_in?
      session[:url] = params[:url]
      redirect_to login_codemarklet_index_path
      return
    end

    @topics = Topic.all

    resource = Link.load(url: params[:url] || session[:url])
    codemark = CodemarkRecord.for_user_and_resource(current_user.try(:id), resource.try(:id))
    codemark ||= CodemarkRecord.new(:resource => resource.link_record, :user => current_user)

    @codemark = PresentCodemarks.present(codemark, current_user)
  end

  def chrome_extension
    redirect_to new_codemarklet_path(params)
  end

  def login
    @callback_url = new_codemarklet_path
  end
end
