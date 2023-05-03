class TimeRequestPolicy < ApplicationPolicy
  def index?
    user.admin || user == record.first.user_request.user
  end

  def show?
    user.admin || user == record.user_request.user
  end

  def update?
    (record.user_request.state == "pending") ? user.admin || user == record.user_request.user : false
  end
end
