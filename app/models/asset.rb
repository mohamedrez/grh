class Asset < ApplicationRecord
  belongs_to :user

  validates :category, :serial, :date_assigned, presence: true

  enum :category, %i[computers peripherals office_equipment software_licenses mobile_devices networking_equipment security_systems other], prefix: :user_category
end
