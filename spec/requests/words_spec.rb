require 'rails_helper'

RSpec.describe "Words", type: :request do
  let(:user) { create(:user) }
  let(:large_category) { create(:large_category) }
  let(:category_a) { create(:category, large_category: large_category) }
  let(:category_b) { create(:category, large_category: large_category) }
  let!(:word_in_a) { create(:word, category: category_a, level: 1) }
  let!(:word_in_b) { create(:word, category: category_b, level: 1) }

  context "未ログインの場合" do
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

    # 大カテゴリ配下に絞ってからfindしているため、他の大カテゴリのIDは弾かれる
    it "他の大カテゴリ配下のcategory_idを指定すると404になる" do
      other_category = create(:category, large_category: create(:large_category))

      get words_path(large_category_id: large_category.id, level: 1, category_id: other_category.id)

      expect(response).to have_http_status(:not_found)
    end

    it "存在しない大カテゴリIDを指定すると404になる" do
      get words_path(large_category_id: 0, level: 1)

      expect(response).to have_http_status(:not_found)
    end

    # カテゴリを1つも持たない大カテゴリでは @categories.first が nil になり、
    # 以前は NoMethodError(500)になっていた
    it "カテゴリを持たない大カテゴリでは500ではなく404になる" do
      empty_large_category = create(:large_category)

      get words_path(large_category_id: empty_large_category.id, level: 1)

      expect(response).to have_http_status(:not_found)
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

    it "存在しない単語IDを指定すると404になる" do
      get word_path(id: 0)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /words/search" do
    before { sign_in user }

    it "検索語を含む単語がヒットする" do
      get search_words_path(q: { term_cont: word_in_a.term })

      expect(response).to have_http_status(:success)
      expect(response.body).to include(word_in_a.term)
    end

    # 検索結果はビューでword.category.nameを参照するため、eager loadingが
    # 外れると該当語のcategory_id数(=SELECT categories回数)だけN+1が発生する
    it "検索結果が複数カテゴリにまたがってもcategoriesのクエリが増えない" do
      category_c = create(:category, large_category: large_category)
      create(:word, category: category_c, term: "共通キーワード単語C")
      create(:word, category: category_a, term: "共通キーワード単語A")

      category_queries = 0
      counter = ->(_name, _start, _finish, _id, payload) do
        category_queries += 1 if payload[:sql]&.include?('"categories"')
      end

      ActiveSupport::Notifications.subscribed(counter, "sql.active_record") do
        get search_words_path(q: { term_cont: "共通キーワード" })
      end

      expect(response.body).to include("共通キーワード単語C").and include("共通キーワード単語A")
      expect(category_queries).to be <= 1
    end

    it "検索語が未指定なら何も表示しない" do
      get search_words_path

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include(word_in_a.term)
      expect(response.body).not_to include(word_in_b.term)
    end

    # Ransack 4系ではモデル側で検索対象を明示的に許可する必要がある。
    # Wordはtermのみ許可しているため、descriptionでは検索できない。
    it "許可していない属性(description)では検索できない" do
      create(:word, category: category_a, term: "ヒットしない単語", description: "レア説明文XYZ")

      get search_words_path(q: { description_cont: "レア説明文XYZ" })

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include("ヒットしない単語")
    end
  end
end
