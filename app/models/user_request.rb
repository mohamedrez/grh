class UserRequest < ApplicationRecord
  after_create :mailing_manager
  after_update :mailing_employee, unless: :is_pending?

  belongs_to :user
  belongs_to :managed_by, class_name: "User", optional: true
  belongs_to :requestable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  scope :pending, -> { where(state: "pending") }
  scope :approved, -> { where(state: "approved") }
  scope :rejected, -> { where(state: "rejected") }

  enum state: {pending: 0, approved: 1, rejected: 2}

  private

  def is_pending?
    pending?
  end

  def mailing_manager
    employee = User.find(user_id)
    RequestMailer.with(request: self, request_message: "We wanted to let you know that there is a new request by #{employee.full_name} waiting for you.").mailing.deliver_now
  end

  def mailing_employee
    employee = User.find(user_id)
    manager = User.find(employee.manager_id)
    RequestMailer.with(request: self, request_message: "We wanted to let you know that your request was #{state} by #{manager.full_name}.").mailing.deliver_now
  end
end
