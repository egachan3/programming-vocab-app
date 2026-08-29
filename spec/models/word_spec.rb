require 'rails_helper'

RSpec.describe Word, type: :model do
  describe "バリデーション" do
    it "term・description・levelが揃っていれば有効" do
      expect(build(:word)).to be_valid
    end

    it "termが空なら無効" do
      word = build(:word, term: "")
      expect(word).to be_invalid
      expect(word.errors[:term]).to be_present
    end

    it "descriptionが空なら無効" do
      word = build(:word, description: "")
      expect(word).to be_invalid
      expect(word.errors[:description]).to be_present
    end

    it "levelが空なら無効" do
      word = build(:word, level: nil)
      expect(word).to be_invalid
      expect(word.errors[:level]).to be_present
    end

    # レベルは1〜3の3段階で運用しているため、範囲外は弾く
    [ 0, 4 ].each do |invalid_level|
      it "levelが#{invalid_level}なら無効" do
        expect(build(:word, level: invalid_level)).to be_invalid
      end
    end

    [ 1, 2, 3 ].each do |valid_level|
      it "levelが#{valid_level}なら有効" do
        expect(build(:word, level: valid_level)).to be_valid
      end
    end
  end

  describe "関連" do
    it "categoryが無ければ無効" do
      expect(build(:word, category: nil)).to be_invalid
    end

    it "削除すると紐づく学習記録も削除される" do
      word = create(:word)
      create(:learning_record, word: word)

      expect { word.destroy }.to change(LearningRecord, :count).by(-1)
    end
  end
end
