require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "未ログインならトップページを表示する" do
      get root_path

      expect(response).to have_http_status(:success)
    end

    it "ログイン済みなら単語カテゴリ一覧にリダイレクトされる" do
      sign_in create(:user)

      get root_path

      expect(response).to redirect_to(large_categories_path)
    end
  end

  describe "GET /terms" do
    it "利用規約ページを表示する" do
      get terms_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "プライバシーポリシーページを表示する" do
      get privacy_path

      expect(response).to have_http_status(:success)
    end
  end
end
