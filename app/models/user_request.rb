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
    subject = "You have a new request"
    email = user.email
    NotificationMailerJob.perform_later(self, subject, email)
  end

  def mailing_employee
    subject = "Your request has been reviewd"
    email = user.manager.email
    NotificationMailerJob.perform_later(self, subject, email)
  end
end
