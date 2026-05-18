class LargeCategory < ApplicationRecord
  has_many :categories, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
