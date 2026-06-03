class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def top
    redirect_to large_categories_path if user_signed_in?
  end

  def terms; end

  def privacy; end
end
