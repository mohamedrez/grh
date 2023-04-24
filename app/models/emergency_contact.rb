class EmergencyContact < ApplicationRecord
  belongs_to :user
  validates :name, :phone, presence: true

  enum :relationship, %i[brother daughter father freind husband moder sister son wife], prefix: :user_contract
end
