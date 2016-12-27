class Book < ApplicationRecord
  belongs_to :category

  has_many :reviews, dependent: :destroy
  has_many :passive_rates, class_name: Rating.name, foreign_key: :book_id,
    dependent: :destroy
  has_many :raters, through: :passive_rates, source: :user

  mount_uploader :image, PictureUploader

  VALID_DATE_REGEX = /\A\d{4}\-(?:0?[1-9]|1[0-2])\-(?:0?[1-9]|[1-2]\d|3[01])\z/i
  validates :title, presence: true,
    length: {maximum: Settings.maximum_name_email}, uniqueness: true
  validates :description, presence: true
  validates :publish_date, presence: true, format: {with: VALID_DATE_REGEX}
  validates :author, presence: true

  scope :more_rate, -> do
    order(rating: :desc).limit Settings.limit_book
  end
  scope :show_newest, -> do
    order(created_at: :desc).limit Settings.limit_book
  end
  scope :filter_newest, ->{order created_at: :desc}
  scope :search, ->search do
    where "title LIKE ? OR author LIKE ?", "%#{search}%", "%#{search}%"
  end
  scope :search_by_category, ->category_id do
    where category_id: category_id
  end
end
