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
    has_role_manager?
  end

  def edit?
    update?
  end

  def update?
    has_role_manager?
  end

  def archive?
    has_role_manager?
  end

  def has_role_manager?
    user.has_role?(:manager)
  end

  relation_scope do |relation|
    next relation if user.has_any_role?([:hr, :admin])

    relation.joins(:owner)
      .where(users: {manager_id: user.id})
  end
end
