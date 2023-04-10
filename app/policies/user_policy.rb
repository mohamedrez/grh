class UserPolicy < ApplicationPolicy
  def index?
    user.admin
  end

  def show?
    user.admin || record == user
  end

  def update?
    user.admin
  end

  def edit?
    update?
  end
end
