class TimeOffRequest < ApplicationRecord
  has_rich_text :content
  has_one :user_request, as: :requestable, dependent: :destroy
  has_one :event, as: :eventable, dependent: :destroy
  after_create :create_user_request
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :start_date, presence: true
  validates :end_date, presence: true

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def overlapping_requests
    requests = TimeOffRequest.where.not(id: id)
    range = start_date..end_date
    requests.select { |request| range.cover?(request.start_date) }
  end
end
