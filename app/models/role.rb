class Role < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  enum name: {hr: 1, admin: 2, accountant: 3}
end
