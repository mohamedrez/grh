class Job < ApplicationRecord
  has_many :job_applications, dependent: :destroy
  validates :title, :location, :overview, :min_salary, :max_salary, :unit, presence: true

  enum job_type: {full_time: 0, part_time: 1}
  enum unit: {hour: 0, day: 1, week: 2, month: 3, year: 4}
  enum status: {open: 0, closed: 1}

  has_rich_text :description

  def color_badge(status)
    if status == "open"
      "green-badge"
    else
      "red-badge"
    end
  end
end
