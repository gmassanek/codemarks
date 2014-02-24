class CommentsController < ApplicationController
  def index
    resource = Resource.find(params[:id])
    render :json => PresentComments.present(resource.comment_threads.includes(:user).includes(:parent))
  end

  def create
    resource = Resource.find(params[:id])
    comment = Comment.build_from(resource, current_user.id, params[:comment][:body])
    comment.parent_id = params[:comment][:parent_id] if params[:comment][:parent_id]
    comment.save

    render :json => PresentComments.new.present(comment), :status => 201
  end

  def update
    comment = Comment.find(params[:id])
    comment.update_attributes(:body => params[:body])

    render :json => PresentComments.new.present(comment), :status => 200
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
