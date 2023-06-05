class Asset < ApplicationRecord
  belongs_to :user

  validates :category, :serial, :date_assigned, presence: true
  validates :category, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}
  validates :serial, numericality: {only_integer: true}

  enum :category, %i[none computers peripherals office_equipment software_licenses mobile_devices networking_equipment security_systems other], prefix: :category
end
