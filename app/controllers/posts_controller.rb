class PostsController < ApplicationController
  include PostsHelper
  
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.where(user_id: [current_user.id, current_user.friends.pluck(:id)].flatten)
                 .order('created_at DESC')
  end

  def show
    @notification = Notification.find(params[:notification_id])
    @notification.seen!
  end

  def new
    @post = current_user.posts.build
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "Post successfully created!"
      redirect_to posts_path
    else
      flash[:alert] = "Something went wrong..."
      # redirect_to posts_path
    end
  end

  def update
    @post.update(post_params)
    flash[:notice] = "Post successfully updated!"
    redirect_to posts_path
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post was successfully deleted!"
    redirect_to posts_path
  end

  def delete_image_attachment
    @image = ActiveStorage::Attachment.find(params[:image_id])
    @image.purge
    redirect_back(fallback_location: root_path)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
