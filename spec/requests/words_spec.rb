require 'rails_helper'

RSpec.describe "Words", type: :request do
  let(:user) { create(:user) }
  let(:large_category) { create(:large_category) }
  let(:category_a) { create(:category, large_category: large_category) }
  let(:category_b) { create(:category, large_category: large_category) }
  let!(:word_in_a) { create(:word, category: category_a, level: 1) }
  let!(:word_in_b) { create(:word, category: category_b, level: 1) }

  describe "未ログイン時" do
    it "単語一覧はログイン画面にリダイレクトされる" do
      get words_path(large_category_id: large_category.id, level: 1)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "単語詳細はログイン画面にリダイレクトされる" do
      get word_path(word_in_a)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "単語検索はログイン画面にリダイレクトされる" do
      get search_words_path(q: { term_cont: word_in_a.term })
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /words" do
    before { sign_in user }

    it "category_idを指定するとそのカテゴリの単語のみ表示される" do
      get words_path(large_category_id: large_category.id, level: 1, category_id: category_b.id)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(word_in_b.term)
      expect(response.body).not_to include(word_in_a.term)
    end

    it "category_id未指定なら最初のカテゴリの単語が表示される" do
      get words_path(large_category_id: large_category.id, level: 1)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(word_in_a.term)
    end
  end

  describe "GET /words/:id" do
    before { sign_in user }

    it "単語の詳細を表示する" do
      get word_path(word_in_a)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(word_in_a.term)
      expect(response.body).to include(word_in_a.description)
    end
  end

  describe "GET /words/search" do
    before { sign_in user }

    it "検索語を含む単語がヒットする" do
      get search_words_path(q: { term_cont: word_in_a.term })

      expect(response).to have_http_status(:success)
      expect(response.body).to include(word_in_a.term)
    end

    it "検索語が未指定なら何も表示しない" do
      get search_words_path

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include(word_in_a.term)
      expect(response.body).not_to include(word_in_b.term)
    end
  end
end
