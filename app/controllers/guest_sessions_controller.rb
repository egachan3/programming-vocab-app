class GuestSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    guest_user = User.find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.hex(16)
    end
    sign_in guest_user
    redirect_to large_categories_path, notice: "ゲストとしてログインしました"
  end
end
