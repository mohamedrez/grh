class Goal < ApplicationRecord
  belongs_to :owner, class_name: "User"

  enum :status, %i[not_achieved partially_achieved completed overpassed], prefix: :status
  enum :level, %i[none important very_important critical], prefix: :level

  validates :title, :start_date, :due_date, presence: true
  validates_comparison_of :due_date, greater_than_or_equal_to: :start_date
  # validates :level, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

  has_rich_text :description

  def self.ransackable_attributes(auth_object = nil)
    ["title", "status", "status_eq", "title_or_owner_first_name_or_owner_last_name_cont"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["owner"]
  end

  def self.importance_sum(goals)
    importance_sum = 0
    goals.each do |goal|
      importance_sum += goal.importance_scale
    end
    importance_sum
  end

  def self.importance_factor(goal:, goals:)
    importance_sum = importance_sum(goals)
    goal.importance_scale / importance_sum.to_d
  end

  def self.completion_factor(goal:, goals:)
    return unless goal.status_scale

    importance_factor = self.importance_factor(goal: goal, goals: goals)
    goal.status_scale * importance_factor
  end

  def self.completion_factor_sum(goals)
    sum = 0
    goals.each do |e|
      sum += Goal.completion_factor(goal: e, goals: goals)
    end
    sum
  end

  def self.importance_factor_sum(goals)
    sum = 0
    goals.each do |e|
      sum += Goal.importance_factor(goal: e, goals: goals)
    end
    sum
  end

  def importance_scale
    case level
    when "important"
      1
    when "very_important"
      2
    when "critical"
      3
    end
  end

  def status_scale
    case status
    when "not_achieved"
      0
    when "partially_achieved"
      80
    when "completed"
      100
    when "overpassed"
      120
    end
  end

  def what_is_the_status?
    if status.nil?
      Goal.human_enum_name(:status, "no_feedback")
    else
      Goal.human_enum_name(:status, status)
    end
  end
end
