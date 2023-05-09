FactoryBot.define do
  factory :comment do
    content { "I wanna a personal break" }
    author { nil }
    commentable { nil }
  end
end
