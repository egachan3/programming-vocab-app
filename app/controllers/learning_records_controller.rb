class LearningRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @records = current_user.learning_records.includes(word: :category)
    @records = case params[:filter]
    when "remembered" then @records.where(remembered: true)
    when "not_remembered" then @records.where(remembered: false)
    else @records
    end
    @records = @records.order(updated_at: :desc)
  end

  def create
    record = LearningRecord.find_or_initialize_by(user: current_user, word_id: params[:word_id])
    record.remembered = params[:remembered] == "true"
    record.save!
    head :ok
  end
end
