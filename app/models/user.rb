class User < ApplicationRecord
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_likes, class_name: :Like.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :liking, through: :active_likes, source: :activity
  has_many :active_rates, class_name: Rating.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :rating, through: :active_rates, source: :book
  has_many :requests
  has_many :comments
  has_many :activities

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  validates :name, presence: true, length: {maximum: Settings.maximum_name_email}
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.minimum}, allow_blank: true
end
