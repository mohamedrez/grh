class UserPolicy < ApplicationPolicy
  def index?
    user.admin
  end

  def show?
    return true
    user.admin || record == user
  end

  def create?
    return true
    user.admin
  end

  def new?
    return true
    create?
  end

  def update?
    return true
    user.admin? || user == record
  end

  def edit?
    return true
    update?
  end
end
