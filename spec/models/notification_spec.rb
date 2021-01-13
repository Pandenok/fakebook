require "rails_helper"

RSpec.describe Notification, type: :model do
  before(:all) do
    @user = create(:user)
    @friend = create(:user)
    @friend_request = FriendRequest.create!(user: @user, friend: @friend, status: :pending)
    @unseen_notification = Notification.create(sent_to: @friend, sent_by: @user, action: "sent", notifiable: @friend_request)
    @seen_notification = Notification.create(sent_to: @friend, sent_by: @user, action: "accepted", status: :seen, notifiable: @friend_request)
  end

  context ".unseen" do
    it "returns notifications with unseen status only" do
      expect(Notification.unseen).to include(@unseen_notification)
      expect(Notification.unseen).not_to include(@seen_notification)
    end
  end

  context ".incoming_friend_request" do
    it "returns notifications about incoming friend requests only" do
      expect(Notification.incoming_friend_request).to include(@unseen_notification)
      expect(Notification.incoming_friend_request).not_to include(@seen_notification)
    end
  end

  context 'enum' do 
    it { should define_enum_for(:status)
          .with_values(
            seen: "Seen",
            unseen: "Unseen"
          )
          .backed_by_column_of_type(:string)
    }
  end

  context 'associations' do
    it { should belong_to(:sent_to).class_name('User') }
    it { should belong_to(:sent_by).class_name('User') }
    it { should belong_to(:notifiable) }
  end

  context 'validations' do
    it { should validate_presence_of(:sent_to) }
    it { should validate_presence_of(:sent_by) }
    it { should validate_presence_of(:action) }
    it { should validate_presence_of(:notifiable) }
  end
end