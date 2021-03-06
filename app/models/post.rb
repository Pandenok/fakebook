class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  
  validates :body, presence: true, unless: -> { images.attached? }                             
  validates :images, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'],
                             size_range: 1..1.megabytes,
                             limit_range: 1..5 }
end
