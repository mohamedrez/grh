class Expense < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  validates :date, :category, :amount, presence: true
end
