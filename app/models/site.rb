class Site < ApplicationRecord
  has_many :users, dependent: :nullify
  validates :name, :code, :address, :phone, presence: true
end
