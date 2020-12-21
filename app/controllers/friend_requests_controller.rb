class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.build(friend_id: @friend.id)
    if @friend_request.save
      @friend_request.pending!
      Notification.create(sent_to: @friend, sent_by: current_user, action: "sent", notifiable: @friend_request)
      flash[:notice] = "Friend request sent!"
    else
      flash[:alert] = "Ooops! Something went wrong!"
    end
    redirect_to users_path
  end

  def update
    @friend_request = FriendRequest.find(params[:id])
    @requestor = User.find(@friend_request.user_id)
    @friend_request.accepted! if @friend_request.pending?
    Notification.create(sent_to: @requestor, sent_by: current_user, action: "accepted", notifiable: @friend_request)
    flash[:notice] = "Friend request accepted!"
    redirect_to users_path
  end

  def destroy
    @sent_friend_request = FriendRequest.find(id: params[:id], user_id: current_user.id)
    @received_friend_request = FriendRequest.find(id: params[:id], friend_id: current_user.id)
    @requestor = User.find(@received_friend_request.user_id)
    if @sent_friend_request
      @sent_friend_request.destroy 
      flash[:notice] = "Friend request removed!"
    elsif @received_friend_request
      @received_friend_request.rejected!
      Notification.create(sent_to: @requestor, sent_by: current_user, action: "rejected", notifiable: @received_friend_request)
      flash[:notice] = "Friend request rejected!"
    end
    redirect_to users_path
  end
end
