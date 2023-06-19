class AdminHrPolicy < ApplicationPolicy
  def index?
    has_any_admin_or_hr_role?
  end

  def new?
    create?
  end

  def create?
    has_any_admin_or_hr_role?
  end

  def edit?
    update?
  end

  def update?
    has_any_admin_or_hr_role?
  end

  def destroy?
    has_any_admin_or_hr_role?
  end

  def has_any_admin_or_hr_role?
    user.has_any_role?([:hr, :admin])
  end
end
