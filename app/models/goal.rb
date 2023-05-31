class Goal < ApplicationRecord
  belongs_to :owner, class_name: "User"

  enum :status, %i[incomplete completed overpass], prefix: :status
  enum :level, %i[none important very_important critical], prefix: :level

  validates :title, :start_date, :due_date, presence: true
  validates_comparison_of :due_date, greater_than_or_equal_to: :start_date
  validates :level, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

  has_rich_text :description

  def self.ransackable_attributes(auth_object = nil)
    ["title", "status", "status_eq", "title_or_owner_first_name_or_owner_last_name_cont"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["owner"]
  end

  def what_is_the_status?
    if status.nil?
      Goal.human_enum_name(:status, "no_feedback")
    else
      Goal.human_enum_name(:status, status)
    end
  end
end
