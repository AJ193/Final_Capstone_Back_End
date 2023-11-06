class Car < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_one_attached :image

  validates :model, presence: true
  validates :year, presence: true
end
