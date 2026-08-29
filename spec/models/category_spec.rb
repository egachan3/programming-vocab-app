require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "バリデーション" do
    it "nameとlarge_categoryが揃っていれば有効" do
      expect(build(:category)).to be_valid
    end

    it "nameが空なら無効" do
      category = build(:category, name: "")
      expect(category).to be_invalid
      expect(category.errors[:name]).to be_present
    end

    it "large_categoryが無ければ無効" do
      expect(build(:category, large_category: nil)).to be_invalid
    end
  end

  describe "関連" do
    it "削除すると配下の単語も削除される" do
      category = create(:category)
      create(:word, category: category)

      expect { category.destroy }.to change(Word, :count).by(-1)
    end
  end
end
