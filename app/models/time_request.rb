class TimeRequest < ApplicationRecord
  has_one :user_request, as: :requestable, dependent: :destroy
  has_rich_text :content

  after_create :create_user_request

  enum :category, %i[none vacation_time sick_time bereavement_time parental_leave remote_work personal_time], prefix: :category

  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :start_date, :end_date, :category, presence: true
  validates :category, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

  delegate :user, to: :user_request

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def overlapping_requests
    requests = TimeRequest.where.not(id: id)
    range = start_date..end_date
    requests.select { |request| range.cover?(request.start_date) }
  end

  def color
    case category
    when "vacation_time"
      "#FFD700"
    when "sick_time"
      "#FF0000"
    when "personal_time"
      "#00FF00"
    when "bereavement_time"
      "#0000FF"
    when "parental_leave"
      "#FF00FF"
    end
  end

  def subtract_pto
    pto_days = user.pto_number
    range = start_date..end_date
    requested_days = range.count

    requested_days -= count_weekend_days(range)
    requested_days -= count_holiday_days(range)

    user.update!(pto_number: [pto_days - requested_days, 0].max)

    user.pto_number
  end

  private

  def count_weekend_days(range)
    range.count { |date| date.saturday? || date.sunday? }
  end

  def count_holiday_days(range)
    Holiday.where(start_date: range, end_date: range).count
  end
end
