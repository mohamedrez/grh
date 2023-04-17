class UserRequestPolicy < ApplicationPolicy
  def index?
    user.admin || user == record.first.user
  end

  def update?
    user.admin?
  end
end
