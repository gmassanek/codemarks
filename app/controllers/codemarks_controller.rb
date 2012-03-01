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
    page = params[:page]
    if page
      finder = FindCodemarks.new({:page => page})
    else
      finder = FindCodemarks.new
    end
    @codemarks = finder.codemarks

    render 'users/dashboard'
  end

end
