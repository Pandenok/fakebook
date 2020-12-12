class CommentsController < ApplicationController
  include CommentsHelper

  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.create(post_id: params[:post_id], body: params[:comment][:body])
    if @comment.save
      unless current_user == @post.user
        Notification.create(sent_to: @post.user, sent_by: current_user, action: "commented", notifiable: @post)
        flash[:notice] = "You commented on the post!"
      end
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_to posts_path
  end

  def destroy
    @comment = current_user.comments.find(params[:post_id])
    @comment.destroy
    flash[:notice] = "Comment is successfully deleted!"
    redirect_to posts_path
  end
end
