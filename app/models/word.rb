class Word < ApplicationRecord
  belongs_to :category
  has_many :learning_records, dependent: :destroy

  validates :term, presence: true
  validates :description, presence: true
  validates :level, presence: true, numericality: { in: 1..3 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[term]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
