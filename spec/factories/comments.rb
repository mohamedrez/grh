FactoryBot.define do
  factory :comment do
    content { "MyText" }
    user_request { nil }
    author { nil }
  end
end
