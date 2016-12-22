class Category < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_email}, uniqueness: true
  scope :show_category_desc, order created_at: :desc
end
