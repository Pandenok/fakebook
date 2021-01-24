class User < ApplicationRecord
  enum gender: { male: 'Male', female: 'Female', custom: 'Custom' }
  
  has_many :friend_requests,
      ->(user) { unscope(where: :user_id)
              .where("user_id = ? OR friend_id = ?", user.id, user.id) },
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

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, foreign_key: :sent_to_id, dependent: :destroy
  has_one_attached :cover_photo, dependent: :purge_later
  has_one_attached :avatar, dependent: :purge_later
  
  validates :firstname, :lastname, presence: true
  validates :cover_photo, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..1.megabytes }
  validates :avatar, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..1.megabytes }

  after_create :send_welcome_email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  def fullname
    [firstname, lastname].join(' ')
  end

  def mutual_friends_with(user)
    self.friends.where(users: {id: user.friends.pluck(:id)})
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.firstname = data["first_name"] if user.firstname.blank?
        user.lastname = data["last_name"] if user.lastname.blank?
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
