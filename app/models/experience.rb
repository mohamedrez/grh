class Experience < ApplicationRecord
  belongs_to :user

  validates :job_title, :company_name, :employment_type, :start_date, :end_date, :country, :city, presence: true

  enum :employment_type, %i[apprenticeship contractor freelancer internship permanent seasonal self_employed other], prefix: :experience
  enum :country, %i[canada cameroon france egypt germany ghana morocco usa other], prefix: :experience_country
end
