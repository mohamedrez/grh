class Experience < ApplicationRecord
  belongs_to :user

  validates :job_title, :company_name, :employment_type, :start_date, :end_date, :country, :city, presence: true

  enum employment_type: {
    apprenticeship: 0,
    contractor: 1,
    freelancer: 2,
    internship: 3,
    permanent: 4,
    seasonal: 5,
    self_employed: 6,
    other_employment_type: 7
  }

  enum country: {
    canada: 0,
    cameroon: 1,
    france: 2,
    egypt: 3,
    germany: 4,
    ghana: 5,
    morocco: 6,
    usa: 7,
    other_country: 8
  }
end
