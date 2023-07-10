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
end
