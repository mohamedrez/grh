FactoryBot.define do
  factory :expense do
    date { "2023-05-18" }
    category { 1 }
    description { "MyText" }
    amount { 1.5 }
  end
end
