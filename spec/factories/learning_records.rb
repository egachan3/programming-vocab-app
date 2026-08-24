FactoryBot.define do
  factory :learning_record do
    user
    word
    remembered { false }
  end
end
