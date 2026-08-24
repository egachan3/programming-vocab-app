FactoryBot.define do
  factory :large_category do
    sequence(:name) { |n| "カテゴリ#{n}" }
  end
end
