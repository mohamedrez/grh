FactoryBot.define do
  factory :experience do
    job_title { "MyString" }
    company_name { "MyString" }
    employment_type { 1 }
    start_date { "2023-04-02" }
    end_date { "2023-04-02" }
    work_description { "MyText" }
    user { nil }
    city { "City name" }
    country { "usa" }
  end
end
