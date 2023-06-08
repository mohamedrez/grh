FactoryBot.define do
  factory :mission_order do
    title { "MyString" }
    start_date { "2023-06-08" }
    end_date { "2023-06-08" }
    indemnity_type { 1 }
    accommodation { 1 }
    mission_type { 1 }
    location { "MyString" }
    site { nil }
    transport_type { 1 }
    description { nil }
  end
end
