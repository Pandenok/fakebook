require "rails_helper"

RSpec.describe FriendRequest, type: :model do
  before(:all) do
    @user = create(:user)
    @friend_a = create(:user)
    @friend_b = create(:user)
    @friend_c = create(:user)
    @accepted_friend_request = FriendRequest.create!(user: @user, friend: @friend_a, status: :accepted)
    @pending_friend_request = FriendRequest.create!(user: @user, friend: @friend_b, status: :pending)
    @nil_friend_request = FriendRequest.create!(user: @user, friend: @friend_c)
  end

  context ".accepted" do
    it "returns friend requests with accepted status only" do
      expect(FriendRequest.accepted).to include(@accepted_friend_request)
      expect(FriendRequest.accepted).not_to include(@pending_friend_request)
      expect(FriendRequest.accepted).not_to include(@nil_friend_request)
    end
  end

  context ".pending" do
    it "returns friend requests with pending status only" do
      expect(FriendRequest.pending).to include(@pending_friend_request)
      expect(FriendRequest.pending).not_to include(@accepted_friend_request)
      expect(FriendRequest.pending).not_to include(@nil_friend_request)
    end
  end

  context 'enum' do 
    it { should define_enum_for(:status)
          .with_values(
            pending: "Pending",
            accepted: "Accepted",
            rejected: "Rejected"
          )
          .backed_by_column_of_type(:string)
    }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name('User') }
  end

  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:friend_id) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:friend_id) }
  end
end