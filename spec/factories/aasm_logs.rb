FactoryBot.define do
  factory :aasm_log do
    actor { nil }
    from_state { "MyString" }
    to_state { "MyString" }
    event { "MyString" }
    aasm_logable { nil }
  end
end
