class StudiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @large_category = LargeCategory.find(params[:large_category_id])
    @level = params[:level].to_i
    @words = Word.joins(:category)
                 .where(categories: { large_category_id: @large_category.id }, level: @level)
                 .order("RANDOM()")
  end
end
