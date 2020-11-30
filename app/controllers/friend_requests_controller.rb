class FriendRequestsController < ApplicationController
  def create
    @friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.build(friend_id: params[:friend_id])
    if @friend_request.save
      @friend_request.pending!
      flash[:notice] = "Friend request sent!"
      # redirect_to root
    else
      flash[:alert] = "Ooops! Something went wrong!"
      redirect_to root
    end
  end

  def update
    @friend_request = FriendRequest.find_by_friend_id(current_user.id)
    @friend_request.accepted! if @friend_request.pending?
    flash[:notice] = "Friend request accepted!"
  end

  def destroy
    @sent_friend_request = FriendRequest.find(id: params[:id], user_id: current_user.id)
    @received_friend_request = FriendRequest.find(id: params[:id], friend_id: current_user.id)
    if @sent_friend_request
      @sent_friend_request.destroy 
      flash[:notice] = "Friend request removed!"
    elsif @received_friend_request
      @received_friend_request.rejected!
      flash[:notice] = "Friend request rejected!"
    end
    # redirect_to root
  end
end
