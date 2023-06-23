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
    has_manager_role_and_manger_of_owner_goal?
  end

  def archive?
    has_manager_role_and_manger_of_owner_goal?
  end

  def view_end_goal_form?
    has_manager_role_and_manger_of_owner_goal?
  end

  def has_manager_role_and_manger_of_owner_goal?
    user.has_role?(:manager) && user == record.owner.manager
  end
end
