class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  enum status: { pending: 'Pending', accepted: 'Accepted', rejected: 'Rejected' }
  scope :accepted, -> { where(status: :accepted) }
  scope :pending, -> { where(status: :pending) }
end
