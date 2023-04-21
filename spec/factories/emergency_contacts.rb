FactoryBot.define do
  factory :emergency_contact do
    name { "MyString" }
    relationship { 1 }
    phone { "MyString" }
    email { "MyString" }
    user { nil }
  end
end
