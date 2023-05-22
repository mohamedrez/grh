FactoryBot.define do
  factory :note do
    user { nil }
    content { "MyText" }
    author { nil }
  end
end
