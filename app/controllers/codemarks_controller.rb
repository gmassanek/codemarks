class CodemarksController < ApplicationController

  def build_linkmark
    @codemark = Codemark.prepare(:link, params[:resource_attrs])
  end

  def create
    topic_ids = params[:tags].keys.collect(&:to_i)
    @codemark = Codemark.create(params[:codemark_attrs], params[:resource_attrs], topic_ids, current_user)

    redirect_to root_path, :notice => 'Thanks!'
  end

  def public
    search_attributes = {}
    search_attributes[:page] = params[:page] if params[:page]
    search_attributes[:order] = params[:by] if params[:page]
    @codemarks = FindCodemarks.new(search_attributes).codemarks

    render 'users/dashboard'
  end

end
