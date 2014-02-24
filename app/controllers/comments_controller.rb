class CommentsController < ApplicationController
  def index
    resource = Resource.find(params[:id])
    render :json => PresentComments.present(resource.comment_threads.includes(:user).includes(:parent))
  end

  def create
    resource = Resource.find(params[:id])
    comment = Comment.build_from(resource, current_user.id, params[:body])
    comment.parent_id = params[:parent_id] if params[:parent_id]
    comment.save

    render :json => PresentComments.new.present(comment), :status => 201
  end

  def destroy
    comment = Comment.find(params[:id])

    if comment.user == current_user
      comment.destroy
      head 204
    else
      head 403
    end
  end
end
