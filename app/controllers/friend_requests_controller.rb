class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend_request, only: [:update, :destroy]

  def create
    @friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.create(
      friend_id: @friend.id, 
      status: :pending
    )
    send_notification_to(@friend, "sent")
    flash[:notice] = "Friend request to #{@friend.firstname} sent!"
    redirect_to users_path
  end

  def update
    @requestor = User.find(@friend_request.user_id)
    @friend_request.accepted! if @friend_request.pending?
    send_notification_to(@requestor, "accepted")
    flash[:notice] = "#{@requestor.firstname}'s friend request accepted!"
    redirect_to users_path
  end

  def destroy
    @requestor = User.find(@friend_request.user_id)
    if @friend_request.user_id == current_user.id
      @friend_request.destroy 
      flash[:notice] = "Friend request removed!"
    else
      @friend_request.rejected!
      send_notification_to(@requestor, "rejected")
      flash[:notice] = "#{@requestor.firstname}'s friend request rejected!"
    end
    redirect_to users_path
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def send_notification_to(user, action)
    Notification.create(
      sent_to: user,
      sent_by: current_user,
      action: action,
      notifiable: @friend_request
    )
  end
end
