FactoryBot.define do
  factory :job_application do
    first_name {"FirstName"}
    last_name {"LastName"}
    job { nil }
    email {"test@gmail.com"}
    phone {"(602) 496-4636"}
    source {"SourceTest"}
    link {"LinkTest"}
    note {"NoteTest"}
    resume { nil }
  end
end
