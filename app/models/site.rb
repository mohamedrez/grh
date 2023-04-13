class Site < ApplicationRecord
  has_many :user, dependent: :destroy
end
