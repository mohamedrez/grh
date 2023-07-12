class Site < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :roles, through: :users
  has_many :mission_orders, dependent: :destroy

  validates :name, :code, :address, :phone, presence: true
end
