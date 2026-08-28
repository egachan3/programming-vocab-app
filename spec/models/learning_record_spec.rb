require 'rails_helper'

RSpec.describe LearningRecord, type: :model do
  describe "バリデーション" do
    it "user・word・rememberedが揃っていれば有効" do
      expect(build(:learning_record)).to be_valid
    end

    it "userが無ければ無効" do
      expect(build(:learning_record, user: nil)).to be_invalid
    end

    it "wordが無ければ無効" do
      expect(build(:learning_record, word: nil)).to be_invalid
    end

    it "rememberedがnilなら無効" do
      record = build(:learning_record, remembered: nil)
      expect(record).to be_invalid
      expect(record.errors[:remembered]).to be_present
    end

    [ true, false ].each do |value|
      it "rememberedが#{value}なら有効" do
        expect(build(:learning_record, remembered: value)).to be_valid
      end
    end
  end

  describe "一意性" do
    # アプリ層のバリデーションではなくDBのユニークインデックスで担保している。
    # find_or_initialize_byは検索と作成が非アトミックなため、
    # 同時リクエスト時の重複作成をDB制約で防いでいる。
    it "同じuserとwordの組み合わせはDB制約により重複作成できない" do
      user = create(:user)
      word = create(:word)
      create(:learning_record, user: user, word: word)

      expect {
        described_class.connection.execute(
          "INSERT INTO learning_records (user_id, word_id, remembered, created_at, updated_at) " \
          "VALUES (#{user.id}, #{word.id}, false, now(), now())"
        )
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "userが異なれば同じwordを記録できる" do
      word = create(:word)
      create(:learning_record, user: create(:user), word: word)

      expect { create(:learning_record, user: create(:user), word: word) }
        .to change(described_class, :count).by(1)
    end
  end
end
