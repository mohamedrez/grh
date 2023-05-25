FactoryBot.define do
  factory :asset do
    category { 1 }
    description { "MyText" }
    serial { "00000000" }
    date_assigned { "2023-04-27" }
    date_returned { "2023-04-27" }
    user { nil }
  end
end
