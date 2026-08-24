require 'rails_helper'

RSpec.describe "GuestSessions", type: :request do
  describe "POST /guest_login" do
    it "ゲストユーザーを作成してログインし、単語カテゴリ一覧にリダイレクトされる" do
      expect do
        post guest_login_path
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(large_categories_path)
      expect(User.last.email).to eq("guest@example.com")
    end

    it "2回目以降は新規作成せず同じゲストユーザーでログインする" do
      post guest_login_path

      expect do
        post guest_login_path
      end.not_to change(User, :count)
    end
  end
end
