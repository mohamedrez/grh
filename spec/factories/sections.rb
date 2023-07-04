FactoryBot.define do
  factory :section do
    name { "MyString" }
    description { "MyText" }
    section_type { 1 }
    review { nil }
  end
end
