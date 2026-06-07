module LargeCategories
  class LevelsController < ApplicationController
    before_action :authenticate_user!

    def index
      @large_category = LargeCategory.find(params[:large_category_id])
      @progress = build_progress
    end

    private

    def build_progress
      [1, 2, 3].each_with_object({}) do |level, hash|
        words = Word.joins(:category).where(categories: { large_category: @large_category }, level: level)
        total = words.count
        learned = words.joins(:learning_records).where(learning_records: { user: current_user }).distinct.count
        hash[level] = { total: total, learned: learned }
      end
    end
  end
end
