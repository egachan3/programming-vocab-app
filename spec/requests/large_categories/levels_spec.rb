require 'rails_helper'

RSpec.describe "LargeCategories::Levels", type: :request do
  let(:user) { create(:user) }
  let(:large_category) { create(:large_category) }
  let(:category) { create(:category, large_category: large_category) }
  let!(:remembered_word) { create(:word, category: category) }
  let!(:not_remembered_word) { create(:word, category: category) }

  before { sign_in user }

  describe "GET /large_categories/:large_category_id/levels" do
    it "覚えたと記録した単語のみ進捗にカウントされる(覚えていないは含めない)" do
      create(:learning_record, user: user, word: remembered_word, remembered: true)
      create(:learning_record, user: user, word: not_remembered_word, remembered: false)

      get large_category_levels_path(large_category_id: large_category.id)

      expect(response).to have_http_status(:success)
      page = Capybara::Node::Simple.new(response.body)
      expect(page).to have_css("span", text: "1 / 2語")
    end
  end
end
