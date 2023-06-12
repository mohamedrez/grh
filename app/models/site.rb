class Site < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :mission_orders, dependent: :destroy
end
