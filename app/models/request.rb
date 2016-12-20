class Request < ApplicationRecord
  belongs_to :user

  validates :book_title, presence: true,
    length: {maximum: Settings.maximum_name_email}
  validates :user_id, presence: true
end
