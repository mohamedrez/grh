class GoalPolicy < ApplicationPolicy
  def show?
    user.has_any_role?([:hr, :admin]) ||
      (user == record.owner) ||
      (user == record.owner.manager)
  end

  def new?
    create?
  end

  def create?
    user.has_role?(:manager)
  end

  def edit?
    update?
  end

  def update?
    user.has_role?(:manager) && user == record.owner.manager
  end

  def archive?
    user.has_role?(:manager) && user == record.owner.manager
  end
end
