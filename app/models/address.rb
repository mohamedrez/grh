class Address < ApplicationRecord
  belongs_to :user

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
