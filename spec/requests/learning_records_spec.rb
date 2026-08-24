require 'rails_helper'

RSpec.describe "LearningRecords", type: :request do
  let(:user) { create(:user) }
  let(:word) { create(:word) }

  before { sign_in user }

  describe "POST /learning_records" do
    it "同じ単語を複数回記録しても学習履歴は1件のまま更新される" do
      expect do
        post learning_records_path, params: { word_id: word.id, remembered: "true" }
      end.to change(LearningRecord, :count).by(1)

      expect do
        post learning_records_path, params: { word_id: word.id, remembered: "false" }
      end.not_to change(LearningRecord, :count)

      record = LearningRecord.find_by(user: user, word: word)
      expect(record.remembered).to eq(false)
    end

    it "同じuser_id/word_idの組み合わせはDB制約により重複作成できない" do
      create(:learning_record, user: user, word: word, remembered: false)

      expect do
        LearningRecord.connection.execute(
          "INSERT INTO learning_records (user_id, word_id, remembered, created_at, updated_at) " \
          "VALUES (#{user.id}, #{word.id}, false, now(), now())"
        )
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
