FactoryBot.define do
  factory :expense do
    user { nil }
    date { "2023-05-18" }
    category { 1 }
    description { "MyText" }
    amount { 1.5 }
    status { 0 }
  end
end
