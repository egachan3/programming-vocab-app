require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  let(:guest) { create(:user, email: "guest@example.com") }
  let(:user)  { create(:user) }

  # ゲストは全員が共有する1つのアカウントのため、
  # 編集・更新・退会のいずれも行えないようにしている。
  describe "ゲストユーザーの場合" do
    before { sign_in guest }

    it "アカウント編集画面にアクセスできない" do
      get edit_user_registration_path

      expect(response).to redirect_to(large_categories_path)
      expect(flash[:alert]).to eq("ゲストユーザーはこの操作を行えません。アカウント登録してください。")
    end

    it "アカウント情報を更新できない" do
      expect {
        patch user_registration_path, params: {
          user: { email: "changed@example.com", current_password: "password123" }
        }
      }.not_to change { guest.reload.email }

      expect(response).to redirect_to(large_categories_path)
    end

    it "アカウントを削除できない" do
      guest # 先に作成しておく

      expect { delete user_registration_path }.not_to change(User, :count)

      expect(response).to redirect_to(large_categories_path)
    end
  end

  describe "通常ユーザーの場合" do
    before { sign_in user }

    it "アカウント編集画面にアクセスできる" do
      get edit_user_registration_path

      expect(response).to have_http_status(:success)
    end

    it "アカウントを削除できる" do
      user # 先に作成しておく

      expect { delete user_registration_path }.to change(User, :count).by(-1)
    end
  end
end
