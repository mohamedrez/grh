require_relative "has_admin_hr_role"

class HolidayPolicy < ApplicationPolicy
  include HasAdminHrRole
end
