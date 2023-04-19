FactoryBot.define do
  factory :user_request do
    state { :pending }
    user { nil }
    managed_by { nil }
    requestable { nil }
  end
end
