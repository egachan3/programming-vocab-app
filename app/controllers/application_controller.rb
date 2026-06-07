class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def after_sign_in_path_for(resource)
    large_categories_path
  end

  def guest_user?
    current_user&.email == "guest@example.com"
  end
  helper_method :guest_user?

  def redirect_guest_user
    if guest_user?
      redirect_to large_categories_path, alert: "ゲストユーザーはこの操作を行えません。アカウント登録してください。"
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
