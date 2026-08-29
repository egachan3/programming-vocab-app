require 'rails_helper'

RSpec.describe "LearningRecords", type: :request do
  let(:user) { create(:user) }
  let(:word) { create(:word) }

  context "未ログインの場合" do
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
    #
    # 競合相手が先にINSERTを終えた直後の状態を再現するため、
    # find_or_initialize_by だけを差し替えて「既存レコードを見つけられなかった」状況を作る。
    # save! は本物のまま実行するので、RecordNotUnique はDBのユニークインデックスが実際に発生させる。
    it "保存が一意制約違反になっても、既存レコードを更新して正常終了する" do
      create(:learning_record, user: user, word: word, remembered: false)

      allow(LearningRecord).to receive(:find_or_initialize_by)
        .with(user: user, word_id: word.id.to_s)
        .and_return(LearningRecord.new(user: user, word: word))

      expect {
        post learning_records_path, params: { word_id: word.id, remembered: "true" }
      }.not_to change(LearningRecord, :count)

      expect(response).to have_http_status(:ok)
      expect(LearningRecord.find_by(user: user, word: word).remembered).to be(true)
    end
  end

  describe "GET /learning_records" do
    # 画面には「覚えた」「覚えていない」というラベルが存在するため、
    # 部分一致による誤判定を避けて無関係な語をテストデータに使う
    let!(:remembered_record)     { create(:learning_record, user: user, word: create(:word, term: "アルファ"), remembered: true) }
    let!(:not_remembered_record) { create(:learning_record, user: user, word: create(:word, term: "ベータ"), remembered: false) }

    before { sign_in user }

    it "絞り込みなしでは全ての記録が表示される" do
      get learning_records_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(remembered_record.word.term)
        .and include(not_remembered_record.word.term)
    end

    it "filter=rememberedでは覚えた記録のみ表示される" do
      get learning_records_path(filter: "remembered")

      expect(response.body).to include(remembered_record.word.term)
      expect(response.body).not_to include(not_remembered_record.word.term)
    end

    it "filter=not_rememberedでは覚えていない記録のみ表示される" do
      get learning_records_path(filter: "not_remembered")

      expect(response.body).to include(not_remembered_record.word.term)
      expect(response.body).not_to include(remembered_record.word.term)
    end

    it "他のユーザーの記録は表示されない" do
      others_word = create(:word, term: "ガンマ")
      create(:learning_record, user: create(:user), word: others_word)

      get learning_records_path

      expect(response.body).not_to include(others_word.term)
    end
  end
end
