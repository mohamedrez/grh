class UserPolicy < ApplicationPolicy
  def index?
    user.admin
  end

  def show?
    user.admin || record == user
  end

  def create?
    user.admin
  end

  def new?
    create?
  end

  def update?
    user.admin? || user == record
  end

  def edit?
    update?
  end
end
