class TimeOffRequest < ApplicationRecord
  has_rich_text :content
  has_one :user_request, as: :requestable, dependent: :destroy
  has_one :event, as: :eventable, dependent: :destroy
  after_create :create_user_request, :create_event
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :start_date, :end_date, :category, presence: true

  enum :category, %i[vacation_time sick_time personal_time bereavement_time parental_leave], prefix: :time_off_request_category

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def create_event
    Event.create(user_id: user_id, eventable: self, start_at: start_date, end_at: end_date)
  end

  def overlapping_requests
    requests = TimeOffRequest.where.not(id: id)
    range = start_date..end_date
    requests.select { |request| range.cover?(request.start_date) }
  end
end
