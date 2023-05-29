FactoryBot.define do
  factory :goal do
    title { "MyString" }
    owner { nil }
    status { nil }
    start_date { "2023-05-25" }
    due_date { "2023-05-28" }
    level { 1 }
    author { nil }
    end_goal_description { nil }
  end
end
