class Experience < ApplicationRecord
  belongs_to :user
  enum :employment_type, %i[apprenticeship contractor freelancer internship permanent seasonal self_employed other], prefix: :experience
end
