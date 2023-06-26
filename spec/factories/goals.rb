FactoryBot.define do
  factory :goal do
    title { "MyString" }
    owner { nil }
    status { nil }
    year { 2023 }
    level { 1 }
    author_id { (create :user).id }
    end_goal_description { nil }
  end
end
