class Expense < ApplicationRecord
  belongs_to :user

  has_many_attached :receipts

  enum :category, ["--None--", "Travel Expenses", "Meal and Entertainment Expenses", "Training and Development Expenses", "Office Supplies and Equipment Expenses", "Recruitment Expenses", "Employee Benefits Expenses", "Miscellaneous Expenses"], prefix: :category
  enum status: {pending: 0, approved: 1, rejected: 2, paid: 3}

  validates :date, :category, :amount, presence: true

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
