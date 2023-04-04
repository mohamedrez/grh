FactoryBot.define do
  factory :education do
    school { "MyString" }
    country { 1 }
    city { "MyString" }
    education_level { 1 }
    study_field { 1 }
    start_date { "2023-04-02" }
    end_date { "2023-04-02" }
    still_on_this_course { false }
    user { nil }
  end
end
