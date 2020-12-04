class LikesController < ApplicationController
  def create
    current_user.likes.create(post_id: params[:post_id])
    flash[:notice] = "You liked the post!"
    redirect_to posts_path
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
    flash[:notice] = "You unliked the post!"
    redirect_to posts_path
  end
end
