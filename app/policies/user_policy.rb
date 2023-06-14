class UserPolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies

  def create?
    user.has_any_role?([:hr, :admin])
  end

  def show?
    true
  end

  def update?
    user.has_any_role?([:hr, :admin])
  end

  def view_full_profile?
    user.has_any_role?([:hr, :admin]) ||
      user.id == record.id ||
      user.id == record.manager.id
  end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  # relation_scope do |relation|
  #   next relation if user.admin?
  #   relation.where(user: user)
  # end
end
