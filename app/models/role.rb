class Role < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  enum name: {
    hr: 1,
    admin: 2,
    accountant: 3,
    manager: 4,
    hr_site_manager: 5,
    accountant_site_manager: 6,
    holding_treasury_manager: 7
  }
end
