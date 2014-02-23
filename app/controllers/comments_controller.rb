class CommentsController < ApplicationController
  def index
    resource = Resource.find(params[:id])
    render :json => PresentComments.present(resource.comment_threads.includes(:user).includes(:parent))
  end
end
