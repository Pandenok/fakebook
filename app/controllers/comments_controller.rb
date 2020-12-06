class CommentsController < ApplicationController
  def create
    current_user.comments.create(post_id: params[:post_id])
    flash[:notice] = "You commented on the post!"
    redirect_to posts_path
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comment is successfully deleted!"
    redirect_to posts_path
  end
end
