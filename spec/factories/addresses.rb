FactoryBot.define do
  factory :address do
    street { "MyString" }
    city { "MyString" }
    zipcode { "MyString" }
    country { 1 }
    user { nil }
  end
end
