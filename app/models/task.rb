class Task < ApplicationRecord
  validates :title, :due_date, :link, :description, presence: true
  belongs_to :user
  belongs_to :author, class_name: "User"

  enum status: {to_do: 0, in_progress: 1, completed: 2}
end
