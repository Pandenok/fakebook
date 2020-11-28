class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum gender: { Male: 'Male', Female: 'Female', Custom: 'Custom' }
  has_many :friend_requests
  has_many :friends, -> { FriendRequest.accepted }, through: :friend_requests
end
