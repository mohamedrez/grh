class MissionOrderPolicy < ApplicationPolicy
  def show?
    user.has_any_role?([:hr, :admin]) ||
      (user.id == record.user.id) ||
      (user.id == record.user.manager_id)
  end

  def approve?
    user.has_any_role?([:hr, :admin]) ||
      user.id == record.user.manager_id
  end

  def validate_mission_order_by_manager?
    true
  end

  def validate_mission_order_by_hr?
    true
  end

  def pay_mission_order_by_accountant?
    true
  end

  def pay_mission_order_by_holding_treasury?
    true
  end
end
