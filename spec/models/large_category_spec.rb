require 'rails_helper'

RSpec.describe LargeCategory, type: :model do
  describe "バリデーション" do
    it "nameがあれば有効" do
      expect(build(:large_category)).to be_valid
    end

    it "nameが空なら無効" do
      large_category = build(:large_category, name: "")
      expect(large_category).to be_invalid
      expect(large_category.errors[:name]).to be_present
    end

    it "nameが重複していれば無効" do
      create(:large_category, name: "Ruby")
      expect(build(:large_category, name: "Ruby")).to be_invalid
    end
  end

  describe "関連" do
    it "削除すると配下のカテゴリと単語も削除される" do
      large_category = create(:large_category)
      category = create(:category, large_category: large_category)
      create(:word, category: category)

      expect { large_category.destroy }
        .to change(Category, :count).by(-1)
        .and change(Word, :count).by(-1)
    end
  end
end
