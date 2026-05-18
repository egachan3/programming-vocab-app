FactoryBot.define do
  factory :word do
    term { "MyString" }
    description { "MyText" }
    code_example { "MyText" }
    level { 1 }
    category { nil }
  end
end
