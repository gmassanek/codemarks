class CommentsController < ApplicationController
  def create
    comment_params = params[:comment]
    comment_params[:author_id] = current_user.id
    @comment = Comment.create(comment_params)
    @codemark_li_id = "codemark_record_#{@comment.codemark_id}"
  end
end
