class Goal < ApplicationRecord
  belongs_to :owner, class_name: "User"

  enum :status, %i[none not_started on_track progressing off_track completed incomplete], prefix: :status

  validates :title, :start_date, :due_date, presence: true
  validates_comparison_of :due_date, greater_than_or_equal_to: :start_date
  validates :status, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

  has_rich_text :description
end
