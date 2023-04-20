class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :user
  after_create :publish_new_notification_event
  def color
    case eventable_type
    when "TimeOffRequest"
      "#853131"
    when "WorkFromHomeRequest"
      "#28a745"
    when "SickLeaveRequest"
      "#ffc107"
    else
      "#dc3545"
    end
  end

  private

  def publish_new_notification_event
    NotificationPublisher.new.new_notification(self, "New Request")
  end
end
