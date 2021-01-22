require 'rails_helper'

RSpec.describe "FriendRequests", type: :request do
  before do
    @user = create(:user)
    @potential_friend = create(:user)
  end

  describe "GET friend_requests#create" do
    context "WHEN unauthorized" do
      it "requires login" do
        post friend_requests_path, params: { friend_id: @potential_friend.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "creates a new friend request" do
        post friend_requests_path, params: { friend_id: @potential_friend.id }

        expect(response).to have_http_status(302)
        
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq "Friend request to #{@potential_friend.firstname} sent!"
        expect(@user.friend_requests.pending.count).to eq(1)
      end

      it "sends a notification to potential friend" do
        post friend_requests_path, params: { friend_id: @potential_friend.id }

        expect(@potential_friend.notifications.last.sent_by).to eq(@user)
        expect(@potential_friend.notifications.last.action).to eq('sent')
      end
    end
  end

  describe "PATCH friend_requests#update" do
    before do
      @pending_friend_request = @user.friend_requests.create(friend_id: @potential_friend.id, status: :pending)
    end

    context "WHEN unauthorized" do
      it "requires login" do
        patch friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@potential_friend, scope: :user) }

      it "establishes a mutual friendship" do
        patch friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

        expect(response).to have_http_status(302)
        
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq "#{@user.firstname}'s friend request accepted!"
        expect(@user.friends).to include(@potential_friend)
        expect(@potential_friend.friends).to include(@user)
      end

      it "sends a notification to new friend" do
        patch friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

        expect(@user.notifications.last.sent_by).to eq(@potential_friend)
        expect(@user.notifications.last.action).to eq('accepted')
      end
    end
  end

  describe "DELETE friend_requests#destroy" do
    before do
      @pending_friend_request = @user.friend_requests.create(friend_id: @potential_friend.id, status: :pending)
    end

    context "WHEN unauthorized" do
      it "requires login" do
        delete friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      context "WHEN action is performed by user" do
        before { login_as(@user, scope: :user) }

        it "cancels friend request" do
          delete friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

          expect(response).to have_http_status(302)
          
          follow_redirect!

          expect(response).to have_http_status(:ok)
          expect(flash[:notice]).to eq "Friend request removed!"
        end
      end

      context "WHEN action is performed by potential friend" do
        before { login_as(@potential_friend, scope: :user) }

        it "declines friend request" do
          delete friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

          expect(response).to have_http_status(302)
          
          follow_redirect!

          expect(response).to have_http_status(:ok)
          expect(flash[:notice]).to eq "#{@user.firstname}'s friend request rejected!"
        end

        it "sends a notification to user" do
          delete friend_request_path(@pending_friend_request), params: { id: @pending_friend_request.id }

          expect(@user.notifications.last.sent_by).to eq(@potential_friend)
          expect(@user.notifications.last.action).to eq('rejected')
        end
      end
    end
  end
end
