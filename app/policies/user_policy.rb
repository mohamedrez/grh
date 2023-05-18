class UserPolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies

  def index?
    user.admin?
  end

  def show?
    user.admin? || user == record || user == record.manager
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || user == record
  end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  # relation_scope do |relation|
  #   next relation if user.admin?
  #   relation.where(user: user)
  # end
end
