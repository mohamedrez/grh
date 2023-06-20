require_relative "has_admin_hr_role"

class RolePolicy < ApplicationPolicy
  include HasAdminHrRole
end
