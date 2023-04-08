class UserPolicy < ApplicationPolicy
  def index?
    is_admin?
  end

  def update?
    is_admin?
  end

  def edit?
    update?
  end

  private

  def is_admin?
    @user.admin ? true : false
  end
end
