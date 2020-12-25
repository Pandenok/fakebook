class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]
  
  enum gender: { male: 'Male', female: 'Female', custom: 'Custom' }
  
  has_many :friend_requests,
      ->(user) { unscope(where: :user_id)
              .where("user_id = ? OR friend_id = ?", user.id, user.id)
              .pending },
    inverse_of: :user,
    class_name: "FriendRequest",
    dependent: :destroy

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

  has_many :posts
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :sent_to_id, dependent: :destroy
  has_one_attached :cover_photo
  has_one_attached :avatar

  def mutual_friends_with(user)
    self.friends.where(users: {id: user.friends.pluck(:id)})
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      name_split = auth.info.name.split(" ")
      user.lastname = name_split[1]
      user.firstname = name_split[0]
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
