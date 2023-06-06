class ReviewSection < ApplicationRecord
  belongs_to :review
  belongs_to :section
end
