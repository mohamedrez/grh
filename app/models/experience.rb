class Experience < ApplicationRecord
  belongs_to :user

  validates :job_title, :company_name, :employment_type, :start_date, :end_date, presence: true

  enum :employment_type, %i[apprenticeship contractor freelancer internship permanent seasonal self_employed other], prefix: :experience
end
