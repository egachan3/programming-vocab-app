class LearningRecordsController < ApplicationController
  before_action :authenticate_user!

  def create
    record = LearningRecord.find_or_initialize_by(user: current_user, word_id: params[:word_id])
    record.remembered = params[:remembered] == "true"
    record.save!
    head :ok
  end
end
