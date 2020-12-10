class CommentsController < ApplicationController
  include CommentsHelper

  before_action :authenticate_user!

  def create
    current_user.comments.create(post_id: params[:post_id], body: params[:comment][:body])
    flash[:notice] = "You commented on the post!"
    redirect_to posts_path
  end

  def destroy
    @comment = current_user.comments.find(params[:post_id])
    @comment.destroy
    flash[:notice] = "Comment is successfully deleted!"
    redirect_to posts_path
  end
end
