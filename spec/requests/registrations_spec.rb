require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /users/edit" do
    it "ゲストユーザーはアクセスできず一覧にリダイレクトされる" do
      guest = create(:user, email: "guest@example.com")
      sign_in guest

      get edit_user_registration_path

      expect(response).to redirect_to(large_categories_path)
      expect(flash[:alert]).to eq("ゲストユーザーはこの操作を行えません。アカウント登録してください。")
    end

    it "通常ユーザーは編集画面にアクセスできる" do
      sign_in create(:user)

      get edit_user_registration_path

      expect(response).to have_http_status(:success)
    end
  end
end
