FactoryBot.define do
  factory :user_request do
    state { "MyString" }
    user { nil }
    managed_by { nil }
    requestable { nil }
  end
end
