class Review < ApplicationRecord
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :name, :start_date, :end_date, :review_type, presence: true

  has_many :review_users, dependent: :destroy
  has_many :users, through: :review_users

  has_many :sections, dependent: :destroy
  has_many :questions, through: :sections

  accepts_nested_attributes_for :sections, reject_if: :all_blank, allow_destroy: true

  enum status: {upcoming: 0, current: 1, ended: 2}
  enum review_type: {manager_review: 0}
end
