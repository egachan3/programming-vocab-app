class LearningRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @records = current_user.learning_records.includes(word: :category)
    @records = case params[:filter]
    when "remembered" then @records.where(remembered: true)
    when "not_remembered" then @records.where(remembered: false)
    else @records
    end
    @records = @records.order(updated_at: :desc).page(params[:page]).per(20)
  end

  def create
    remembered = params[:remembered] == "true"
    record = LearningRecord.find_or_initialize_by(user: current_user, word_id: params[:word_id])
    record.remembered = remembered
    record.save!
    head :ok
  rescue ActiveRecord::RecordNotUnique
    LearningRecord.find_by!(user: current_user, word_id: params[:word_id]).update!(remembered: remembered)
    head :ok
  end
end
