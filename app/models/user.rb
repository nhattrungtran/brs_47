class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {self.email = email.downcase}

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_likes, class_name: Like.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :liking, through: :active_likes, source: :activity
  has_many :active_rates, class_name: Rating.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :rating, through: :active_rates, source: :book
  has_many :active_bookmarks, class_name: Bookmark.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :favouriting, through: :active_bookmarks, source: :book
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

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost?
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
        BCrypt::Password.create string, cost: cost
      end
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest remember_token
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def following? other_user
    following.include? other_user
  end

  def favourite book
    active_bookmarks.create book_id: book.id
  end

  def unfavourite book
    active = active_bookmarks.find_by book_id: book.id
    active.destroy if active
  end

  def favouriting? book
    favouriting.include? book
  end
end
