FactoryBot.define do
  factory :learning_record do
    user { nil }
    word { nil }
    remembered { false }
  end
end
