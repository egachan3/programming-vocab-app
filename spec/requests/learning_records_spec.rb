require 'rails_helper'

RSpec.describe "LearningRecords", type: :request do
  let(:user) { create(:user) }
  let(:word) { create(:word) }

  describe "未ログイン時" do
    it "GET /learning_records はログイン画面にリダイレクトされる" do
      get learning_records_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "POST /learning_records は記録を作成せずログイン画面にリダイレクトされる" do
      expect {
        post learning_records_path, params: { word_id: word.id, remembered: "true" }
      }.not_to change(LearningRecord, :count)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST /learning_records" do
    before { sign_in user }

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

    # 同時リクエストで保存が一意制約違反になった場合でも、
    # rescue節で既存レコードを更新して正常終了することを検証する。
    # 単一プロセスのテストでは競合を再現できないため、保存時に例外を発生させて代替している。
    it "保存が一意制約違反になっても、既存レコードを更新して正常終了する" do
      create(:learning_record, user: user, word: word, remembered: false)

      conflicting = LearningRecord.new(user: user, word: word)
      allow(conflicting).to receive(:save!).and_raise(ActiveRecord::RecordNotUnique)
      allow(LearningRecord).to receive(:find_or_initialize_by).and_return(conflicting)

      expect {
        post learning_records_path, params: { word_id: word.id, remembered: "true" }
      }.not_to change(LearningRecord, :count)

      expect(response).to have_http_status(:ok)
      expect(LearningRecord.find_by(user: user, word: word).remembered).to be(true)
    end
  end

  describe "GET /learning_records" do
    before { sign_in user }

    let!(:remembered_record)     { create(:learning_record, user: user, word: create(:word, term: "覚えた単語"), remembered: true) }
    let!(:not_remembered_record) { create(:learning_record, user: user, word: create(:word, term: "覚えていない単語"), remembered: false) }

    it "絞り込みなしでは全ての記録が表示される" do
      get learning_records_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("覚えた単語").and include("覚えていない単語")
    end

    it "filter=rememberedでは覚えた記録のみ表示される" do
      get learning_records_path(filter: "remembered")

      expect(response.body).to include("覚えた単語")
      expect(response.body).not_to include("覚えていない単語")
    end

    it "filter=not_rememberedでは覚えていない記録のみ表示される" do
      get learning_records_path(filter: "not_remembered")

      expect(response.body).to include("覚えていない単語")
      expect(response.body).not_to include("覚えた単語")
    end

    it "他のユーザーの記録は表示されない" do
      create(:learning_record, user: create(:user), word: create(:word, term: "他人の単語"))

      get learning_records_path

      expect(response.body).not_to include("他人の単語")
    end
  end
end
