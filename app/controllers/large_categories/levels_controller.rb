module LargeCategories
  class LevelsController < ApplicationController
    before_action :authenticate_user!

    def index
      @large_category = LargeCategory.find(params[:large_category_id])
      @progress = build_progress
    end

    private

    def build_progress
      base = Word.joins(:category).where(categories: { large_category: @large_category })
      totals   = base.group(:level).count
      learneds = base.joins(:learning_records)
                     .where(learning_records: { user: current_user })
                     .distinct
                     .group(:level)
                     .count

      (1..3).each_with_object({}) do |level, hash|
        hash[level] = { total: totals[level] || 0, learned: learneds[level] || 0 }
      end
    end
  end
end
