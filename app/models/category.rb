class Category < ApplicationRecord
  belongs_to :large_category
  has_many :words, dependent: :destroy

  validates :name, presence: true
end
