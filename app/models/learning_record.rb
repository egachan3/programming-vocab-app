class LearningRecord < ApplicationRecord
  belongs_to :user
  belongs_to :word

  validates :remembered, inclusion: { in: [ true, false ] }
end
