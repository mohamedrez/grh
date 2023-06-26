class Education < ApplicationRecord
  belongs_to :user

  validates :school, :country, :city, :education_level, :study_field, :start_date, :end_date, presence: true

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

  enum education_level: {
    high_school: 0,
    bachelor: 1,
    master: 2,
    doctorate: 3,
    other_education_level: 4
  }

  enum study_field: {
    architecture_design: 0,
    business_economics: 1,
    education: 2,
    engineering: 3,
    software_engineering: 4,
    other_study_field: 5
  }
end
