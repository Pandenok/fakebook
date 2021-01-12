class FriendRequest < ApplicationRecord
  scope :accepted, -> { where(status: :accepted) }
  scope :pending, -> { where(status: :pending) }

  enum status: { pending: 'Pending', accepted: 'Accepted', rejected: 'Rejected' }
  
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, :friend_id, presence: true
  validates :user_id, uniqueness: { scope: :friend_id }
end
