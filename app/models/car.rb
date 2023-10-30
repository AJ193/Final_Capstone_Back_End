class Car < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :model, presence: true
  validates :year, presence: true
  validates :picture, presence: true
end
