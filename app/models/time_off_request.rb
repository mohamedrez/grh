class TimeOffRequest < ApplicationRecord
  has_rich_text :content
  has_one :user_request, as: :requestable, dependent: :destroy

  after_create :create_user_request
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :start_date, presence: true
  validates :end_date, presence: true

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, requestable: self)
  end

  def who_else_be_out?
    # Check for overlapping date ranges using PostgreSQL's OVERLAPS operator, if available.
    # overlapping_requests = TimeOffRequest.where.not(id: id).where("(start_date, end_date) OVERLAPS (?, ?)", start_date, end_date)

    # Otherwise, fall back to using a combination of BETWEEN and OR operators to check for overlapping date ranges.
    overlapping_requests = TimeOffRequest
      .where.not(id: id)
      .where("`start_date` BETWEEN ? AND ? OR `end_date` BETWEEN ? AND ? OR `start_date` <= ? AND `end_date` >= ?", start_date, end_date, start_date, end_date, start_date, end_date)

    overlapping_requests.map { |request| {user: request.user_request.user, request: request} }
  end

  def day_color(day)
    if (start_date.day == day || end_date.day == day) && Time.zone.today.day == day
      "font-semibold bg-gray-900 text-indigo-600"
    elsif start_date.day == day || end_date.day == day
      "bg-gray-900 font-semibold text-white"
    elsif Time.zone.today.day == day
      "font-semibold text-indigo-600 hover:bg-gray-200"
    else
      "text-gray-900 hover:bg-gray-200"
    end
  end
end
