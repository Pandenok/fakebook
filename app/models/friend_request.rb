class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  enum status: { Pending: 'Pending', Accepted: 'Accepted' }
  scope :accepted, -> { where(status: :accepted) }
end
