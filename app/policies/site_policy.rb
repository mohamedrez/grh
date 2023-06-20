require_relative "has_admin_hr_role"

class SitePolicy < ApplicationPolicy
  include HasAdminHrRole
end
