require "test_helper"

class LearningRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "learner@example.com", password: Devise.friendly_token[0, 20])
    large_category = LargeCategory.create!(name: "Ruby")
    category = Category.create!(large_category: large_category, name: "基礎文法")
    @word = Word.create!(category: category, term: "each", description: "繰り返し処理を行うメソッド", level: 1)
    sign_in @user
  end

  test "同じ単語を複数回記録しても学習履歴は1件のまま更新される" do
    assert_difference("LearningRecord.count", 1) do
      post learning_records_path, params: { word_id: @word.id, remembered: "true" }
    end

    assert_no_difference("LearningRecord.count") do
      post learning_records_path, params: { word_id: @word.id, remembered: "false" }
    end

    record = LearningRecord.find_by(user: @user, word: @word)
    assert_equal false, record.remembered
  end

  test "同じuser_id/word_idの組み合わせはDB制約により重複作成できない" do
    LearningRecord.create!(user: @user, word: @word, remembered: false)

    assert_raises(ActiveRecord::RecordNotUnique) do
      LearningRecord.connection.execute(
        "INSERT INTO learning_records (user_id, word_id, remembered, created_at, updated_at) " \
        "VALUES (#{@user.id}, #{@word.id}, false, now(), now())"
      )
    end
  end
end
