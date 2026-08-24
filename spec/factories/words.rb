FactoryBot.define do
  factory :word do
    sequence(:term) { |n| "term#{n}" }
    description { "説明文" }
    level { 1 }
    category
  end
end
