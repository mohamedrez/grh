FactoryBot.define do
  factory :announcement do
    title { "MyString" }
    status { 1 }
    user { nil }
    published_at { "2023-04-27" }
  end
end
