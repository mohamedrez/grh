class Event < ApplicationRecord
  include Wisper::ActiveRecord::Publisher

  after_create :publish_new_notification_event
  subscribe NotificationSubscriber.new

  belongs_to :eventable, polymorphic: true
  belongs_to :user

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
    broadcast(:new_notification, self, "New Request")
  end
end
