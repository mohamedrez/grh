class Role < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  enum name: {admin: 0, hr: 1, accountant: 2, manager: 3}
end
