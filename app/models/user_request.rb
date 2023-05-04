class UserRequest < ApplicationRecord
  after_create :notify_manager

  belongs_to :user
  belongs_to :managed_by, class_name: "User", optional: true
  belongs_to :requestable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  scope :pending, -> { where(state: "pending") }
  scope :approved, -> { where(state: "approved") }
  scope :rejected, -> { where(state: "rejected") }

  enum state: {pending: 0, approved: 1, rejected: 2}

  private

  def notify_manager
    RequestMailer.with(request: self).emailing_the_request.deliver_now
  end
end
