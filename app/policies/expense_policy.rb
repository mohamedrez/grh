class ExpensePolicy < ApplicationPolicy
  def show?
    user.has_any_role?([:hr, :admin]) ||
      (user.id == record.user.id) ||
      (user.id == record.user.manager_id)
  end

  def validate_by_manager?
    user.has_role?(:manager) && user.id == record.user.manager_id
  end

  def validate_by_hr?
    user.has_role?(:hr)
  end

  def pay?
    user.has_role?(:accountant)
  end

  def back_to_modify?
    validate_by_manager? || validate_by_hr? || pay?
  end
end
