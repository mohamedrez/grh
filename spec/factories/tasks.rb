FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    due_date { "2023-07-10" }
    status { 1 }
    link { "MyString" }
    priority { 1 }
    user { nil }
  end
end
