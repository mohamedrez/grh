class Expense < ApplicationRecord
  after_create :create_user_request

  has_one :user_request, as: :requestable, dependent: :destroy

  has_many_attached :receipts

  enum :category, %i[none travel meal_entertainment training_development office_equipment employee_benefits miscellaneous], prefix: :category

  validates :date, :category, :amount, presence: true
  validates :category, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

  delegate :user, to: :user_request

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def receipts=(attachables)
    attachables = Array(attachables).compact_blank

    return unless attachables.any?
    new_attachments = attachables.reject { |attachment| attachment_exists?(attachment) }

    return unless new_attachments.any?
    attachment_changes["receipts"] = ActiveStorage::Attached::Changes::CreateMany.new("receipts", self, receipts.blobs + new_attachments)
  end

  private

  def attachment_exists?(attachment)
    receipts.blobs.any? { |blob| blob.filename.to_s == attachment.original_filename }
  end
end
