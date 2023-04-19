class Holiday < ApplicationRecord
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :name, :start_date, :end_date, presence: true
end
