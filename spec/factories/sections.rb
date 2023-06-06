FactoryBot.define do
  factory :section do
    name { "MyString" }
    description { "MyText" }
    section_type { 1 }
    survey { nil }
  end
end
