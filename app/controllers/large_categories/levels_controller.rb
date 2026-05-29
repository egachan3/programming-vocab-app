module LargeCategories
  class LevelsController < ApplicationController
    before_action :authenticate_user!

    def index
      @large_category = LargeCategory.find(params[:large_category_id])
    end
  end
end
