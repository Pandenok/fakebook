require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = create(:user)
    @friend = create(:user)
    @friend_request = @friend.friend_requests.create(friend_id: @user.id, status: :pending)
    @notification = Notification.create(
      sent_to: @user,
      sent_by: @friend,
      action: "sent",
      notifiable: @friend_request
    )
  end

  context "GET users#index" do
    context "WHEN unauthorized" do
      it "requires login" do
        get users_path

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before do
        @stranger = create(:user)
        login_as(@user, scope: :user)
      end

      it "lists only users who are not already friends or who don’t already have a pending request" do
        get users_path
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(@stranger.fullname)
      end

      it "sets status of all incoming friend requests to 'seen'" do
        get users_path, params: { notification_id: @notification.id }

        expect(@user.notifications.last.action).to eq('sent')
        expect(@user.notifications.last.status).to eq('seen')
      end
    end
  end

  context "GET users#show" do
    context "WHEN unauthorized" do
      it "requires login" do
        get user_path(@user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before { login_as(@user, scope: :user) }

      it "shows user's profile" do
        get user_path(@friend)
        
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(@friend.fullname)
      end

      it "sets status of incoming friend request from another user to 'seen'" do
        get user_path(@friend), params: { notification_id: @notification.id }

        expect(@user.notifications.last.sent_by).to eq(@friend)
        expect(@user.notifications.last.status).to eq('seen')
      end
    end
  end

  context "PATCH users#update" do
    context "WHEN unauthorized" do
      it "requires login" do
        get user_path(@user)

        expect(response).to redirect_to new_user_session_path
      end
    end

    context "WHEN authorized" do
      before do 
        login_as(@user, scope: :user)
        @user_bio = "Go ahead, make my day"
        @user_workplace = Faker::Company.name
      end

      it "updates user's profile" do
        patch user_path(@user), params: { user: { bio: @user_bio, workplace: @user_workplace } }
        
        expect(response).to have_http_status(302)
        
        follow_redirect!

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq "Profile successfully updated"
        expect(response.body).to include(@user_bio)
        expect(response.body).to include(@user_workplace)
      end
    end
  end
end
