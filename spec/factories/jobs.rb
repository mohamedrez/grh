FactoryBot.define do
  factory :job do
    title { "MyString" }
    job_type { 1 }
    location { "MyString" }
    remote { false }
    overview { "MyString" }
    description { nil }
    min_salary { 1 }
    max_salary { 1 }
    unit { 1 }
    status { 1 }
  end
end
