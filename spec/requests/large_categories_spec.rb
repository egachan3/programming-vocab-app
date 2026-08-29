require 'rails_helper'

RSpec.describe "LargeCategories", type: :request do
  let(:user) { create(:user) }
  let!(:ruby)  { create(:large_category, name: "Ruby") }
  let!(:rails) { create(:large_category, name: "Rails") }

  context "未ログインの場合" do
    it "カテゴリ一覧はログイン画面にリダイレクトされる" do
      get large_categories_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /large_categories" do
    before { sign_in user }

    it "登録されている大カテゴリが一覧表示される" do
      get large_categories_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(ruby.name).and include(rails.name)
    end
  end
end
