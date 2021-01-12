class Notification < ApplicationRecord
  scope :unseen, -> { where(status: :unseen) }
  scope :recent, -> { order(created_at: :desc) }
  scope :incoming_friend_request, -> { where(action: "sent") }
  
  enum status: { seen: 'Seen', unseen: 'Unseen' }

  belongs_to :sent_to, class_name: 'User'
  belongs_to :sent_by, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  validates :sent_to, :sent_by, :action, :notifiable, presence: true
end
