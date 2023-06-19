class UserPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user.has_any_role?([:hr, :admin])
  end

  def edit?
    update?
  end

  def update?
    user.has_any_role?([:hr, :admin])
  end

  def view_full_profile?
    user.has_any_role?([:hr, :admin]) ||
      user == record ||
      user == record.manager
  end
end
