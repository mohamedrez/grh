class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :user
  after_create :publish_event_created_event

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

  def publish_event_created_event
    EventPublisher.new.event_created(self)
  end
end
