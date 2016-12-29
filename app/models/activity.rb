class Activity < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy

  enum action_type: [:review, :comment]
end
