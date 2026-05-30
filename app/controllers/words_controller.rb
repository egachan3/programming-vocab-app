class WordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @large_category = LargeCategory.find(params[:large_category_id])
    @level = params[:level].to_i
    @categories = @large_category.categories

    @current_category = if params[:category_id].present?
                          @categories.find(params[:category_id])
    else
                          @categories.first
    end

    @words = @current_category.words.where(level: @level)
  end

  def show
    @word = Word.find(params[:id])
    @category = @word.category
    @large_category = @category.large_category
  end
end
