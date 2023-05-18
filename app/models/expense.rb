class Expense < ApplicationRecord
  belongs_to :user
  enum :category, ["None", "Travel Expenses", "Meal and Entertainment Expenses", "Training and Development Expenses", "Office Supplies and Equipment Expenses", "Recruitment Expenses", "Employee Benefits Expenses", "Miscellaneous Expenses"], prefix: :category
  enum status: {pending: 0, approved: 1, rejected: 2, paid: 3}
  validates :date, :category, :amount, presence: true
end
