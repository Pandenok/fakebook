class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum gender: { Male: 'Male', Female: 'Female', Custom: 'Custom' }
  has_many :accepted_friend_requests,
    ->(user) { unscope(where: :user_id) 
              .where("user_id = ? OR friend_id = ?", user.id, user.id)
              .accepted },
    inverse_of: :user,
    class_name: "FriendRequest",
    dependent: :destroy

  has_many :friends,
    ->(user) { joins("OR users.id = user_id")
              .unscope(where: :user_id)
              .where.not(id: user.id) },
    through: :accepted_friend_requests
end
