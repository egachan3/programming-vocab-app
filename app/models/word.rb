class Word < ApplicationRecord
  belongs_to :category
  has_many :learning_records, dependent: :destroy

  validates :term, presence: true
  validates :description, presence: true
  validates :level, presence: true, numericality: { in: 1..3 }
end
