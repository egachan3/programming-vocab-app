class LargeCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @large_categories = LargeCategory.all
  end
end
