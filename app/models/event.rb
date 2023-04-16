class Event < ApplicationRecord
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
end
