FactoryBot.define do
  factory :time_off_request do
    content { nil }
    start_date { "2023-04-01" }
    end_date { "2023-04-01" }
    user { nil }
  end
end
