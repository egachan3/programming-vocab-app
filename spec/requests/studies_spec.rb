require 'rails_helper'

RSpec.describe "Studies", type: :request do
  let(:user) { create(:user) }
  let(:large_category) { create(:large_category) }
  let(:category) { create(:category, large_category: large_category) }
  let!(:level1_word) { create(:word, category: category, level: 1) }
  let!(:level2_word) { create(:word, category: category, level: 2) }

  context "未ログインの場合" do
    it "テスト画面はログイン画面にリダイレクトされる" do
      get studies_path(large_category_id: large_category.id, level: 1)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /studies" do
    before { sign_in user }

    it "指定したレベルの単語のみ出題対象になる" do
      get studies_path(large_category_id: large_category.id, level: 1)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(level1_word.term)
      expect(response.body).not_to include(level2_word.term)
    end

    it "該当レベルの単語が無ければ「単語がありません」と表示する" do
      get studies_path(large_category_id: large_category.id, level: 3)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("このレベルの単語がありません")
    end

    it "存在しない大カテゴリIDを指定すると404になる" do
      get studies_path(large_category_id: 0, level: 1)

      expect(response).to have_http_status(:not_found)
    end
  end
end
