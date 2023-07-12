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
      "#333D51"
    when "sick_time"
      "#7d7f82"
    when "personal_time"
      "#F4F3EA"
    when "bereavement_time"
      "#354649"
    when "parental_leave"
      "#6C7A89"
    end
  end

  def self.number_of_days_taken_per_year(user_id)
    result_hash = {}

    (Time.current.end_of_year.year - 1..Time.current.end_of_year.year).each do |year|
      year_time_requests = TimeRequest.joins(:user_request).where(user_requests: {user_id: user_id}, start_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      year_holidays = Holiday.where("start_date <= ? AND end_date >= ?", Date.new(year, 12, 31), Date.new(year, 1, 1))

      time_requests_days = 0
      year_time_requests.each do |year_time_request|
        time_requests_days += ((year_time_request.end_date - year_time_request.start_date) + 1).to_i
      end

      holidays_days = 0
      year_holidays.each do |year_holiday|
        holidays_days += ((year_holiday.end_date - year_holiday.start_date) + 1).to_i
      end

      result_hash[year] = time_requests_days - holidays_days
    end

    result_hash
  end
end
