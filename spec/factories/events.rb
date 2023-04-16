FactoryBot.define do
  factory :event do
    start_at { "2023-04-12 12:45:14" }
    end_at { "2023-04-12 12:45:14" }
    eventable { create :time_off_request }
    user { create :user }
  end
end
