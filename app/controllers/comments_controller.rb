class CommentsController < ApplicationController
  include CommentsHelper

  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]

  def edit; end

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.create(post_id: @post.id, body: params[:comment][:body])
    if @comment.save
      unless current_user == @post.user
        Notification.create(sent_to: @post.user, sent_by: current_user, action: "commented", notifiable: @post)
        flash[:notice] = "You commented on the post!"
      end
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.js {}
        format.html { redirect_to root_path, notice: 'Comment was successfully updated.' }
      else
        format.js {}
        format.html { render :edit, alert: 'Something went wrong...' }
      end
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Comment is successfully deleted!"
    redirect_back(fallback_location: root_path)
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end
end
