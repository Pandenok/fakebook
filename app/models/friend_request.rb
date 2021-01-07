class FriendRequest < ApplicationRecord
  scope :accepted, -> { where(status: :accepted) }
  scope :pending, -> { where(status: :pending) }

  enum status: { pending: 'Pending', accepted: 'Accepted', rejected: 'Rejected' }
  
  belongs_to :user
  belongs_to :friend, class_name: "User"
end
