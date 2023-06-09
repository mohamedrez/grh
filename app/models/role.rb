class Role < ApplicationRecord
  belongs_to :user
  enum name: {hr: 1, admin: 2, accountant: 3}
end
