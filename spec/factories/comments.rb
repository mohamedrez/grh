FactoryBot.define do
  factory :comment do
    content { "I wanna a personal break" }
    user_request { nil }
    author { nil }
  end
end
