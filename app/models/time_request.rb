class TimeRequest < ApplicationRecord
  has_one :user_request, as: :requestable, dependent: :destroy
  has_rich_text :content

  after_create :create_user_request

  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validates :start_date, :end_date, :category, presence: true

  enum category: {
    vacation_time: 0,
    sick_time: 1,
    bereavement_time: 3,
    parental_leave: 4,
    remote_work: 5,
    personal_time: 6
  }

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
end
