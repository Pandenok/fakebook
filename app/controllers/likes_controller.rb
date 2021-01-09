class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.likes.create(post_id: params[:post_id])
    unless current_user == @post.user
      Notification.create(sent_to: @post.user, sent_by: current_user, action: "liked", notifiable: @post)
    end
    flash[:notice] = "You liked the post!"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    flash[:notice] = "You unliked the post!"
    redirect_back(fallback_location: root_path)
  end
end
