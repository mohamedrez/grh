class Course < ApplicationRecord
  validates :title, :description, presence: true
  has_rich_text :description
end
