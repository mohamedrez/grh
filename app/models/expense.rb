class Expense < ApplicationRecord
  belongs_to :user

  has_many_attached :receipts

  enum :category, %i[none travel meal_entertainment training_development office_equipment employee_benefits miscellaneous], prefix: :category
  enum status: {pending: 0, approved: 1, rejected: 2, paid: 3}

  validates :date, :category, :amount, presence: true
  validates :category, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

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
