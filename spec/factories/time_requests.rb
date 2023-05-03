FactoryBot.define do
  factory :time_request do
    content { nil }
    start_date { "2023-04-01" }
    end_date { "2023-04-01" }
    category { 0 }
  end
end
