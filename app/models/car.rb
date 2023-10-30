# frozen_string_literal: true

class Car < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_one_attached :image
end
