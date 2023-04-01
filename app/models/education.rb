class Education < ApplicationRecord
  belongs_to :user
  enum :country, %i[canada cameroon france egypt germany ghana morocco usa other], prefix: :education_country
  enum :education_level, %i[high_school bachelor master doctorate other], prefix: :education_level
  enum :study_field, %i[architecture_design business_economics education engineering software_engineering other], prefix: :education_study_field
end
