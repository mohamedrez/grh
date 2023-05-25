FactoryBot.define do
  factory :goal do
    title { "MyString" }
    owner { nil }
    status { 1 }
    start_date { "2023-05-25" }
    due_date { "2023-05-28" }
  end
end
