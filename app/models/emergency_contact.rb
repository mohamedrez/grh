class EmergencyContact < ApplicationRecord
  belongs_to :user

  enum :relationship, %i[none brother daughter father friend husband mother sister son wife], prefix: :user_contract

  validates :name, :phone, presence: true
  validates :relationship, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}
end
