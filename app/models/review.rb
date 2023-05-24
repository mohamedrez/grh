class Review < ApplicationRecord
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :name, :start_date, :end_date, presence: true

  enum status: {upcoming: 0, current: 1, ended: 2}
end
