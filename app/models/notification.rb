class Notification < ApplicationRecord
  belongs_to :sent_to, class_name: 'User'
  belongs_to :sent_by, class_name: 'User'
  belongs_to :notifiable, polymorphic: true
  enum status: { seen: 'Seen', unseen: 'Unseen' }
  scope :unseen, -> { where(status: :unseen) }
  scope :recent, -> { order(created_at: :desc) }
end
