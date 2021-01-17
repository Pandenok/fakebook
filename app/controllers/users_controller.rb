class UsersController < ApplicationController
  include UsersHelper
  
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = 
      User.where.not(id: [
        current_user.id,
        current_user.friends.pluck(:id),
        current_user.friend_requests.pluck(:user_id, :friend_id)
      ].flatten)
    current_user.notifications
      .unseen
      .where(action: "sent")
      .each { |notification| notification.seen! }
  end

  def show
    @posts = @user.posts.order('created_at DESC')
    current_user.notifications
      .unseen
      .where(notifiable_type: "FriendRequest")
      .where(sent_by_id: @user.id)
      .each { |notification| notification.seen! }

    respond_to do |format|
      format.html {}
      format.js {}
    end                              
  end

  def edit; end

  def update
    @user.update(user_params)
    @posts = @user.posts.order('created_at DESC')

    if @user.save
      flash[:notice] = 'Profile successfully updated'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'Something went wrong...'
      render template: 'users/show'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
