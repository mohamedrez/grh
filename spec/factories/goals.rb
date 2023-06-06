FactoryBot.define do
  factory :goal do
    title { "MyString" }
    owner { nil }
    status { nil }
    start_date { Time.now.utc }
    due_date { Time.now.utc + 1.day }
    level { 1 }
    author_id { (create :user).id }
    end_goal_description { nil }
  end
end
