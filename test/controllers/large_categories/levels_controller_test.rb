require "test_helper"

class LargeCategories::LevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "learner@example.com", password: Devise.friendly_token[0, 20])
    @large_category = LargeCategory.create!(name: "Ruby")
    category = Category.create!(large_category: @large_category, name: "基礎文法")
    @remembered_word = Word.create!(category: category, term: "each", description: "繰り返し処理を行うメソッド", level: 1)
    @not_remembered_word = Word.create!(category: category, term: "map", description: "配列を変換するメソッド", level: 1)
    sign_in @user
  end

  test "覚えたと記録した単語のみ進捗にカウントされる(覚えていないは含めない)" do
    LearningRecord.create!(user: @user, word: @remembered_word, remembered: true)
    LearningRecord.create!(user: @user, word: @not_remembered_word, remembered: false)

    get large_category_levels_path(large_category_id: @large_category.id)

    assert_response :success
    assert_select "span", text: "1 / 2語"
  end
end
