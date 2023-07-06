class ExpensePolicy < ApplicationPolicy
  def show?
    user.has_any_role?([:hr, :admin]) ||
      (user.id == record.user.id) ||
      (user.id == record.user.manager_id)
  end

  def validate_expense_by_manager?
    user.has_role?(:manager) && user.id == record.user.manager_id
  end

  def validate_expense_by_hr?
    user.has_role?(:hr)
  end

  def pay_expense?
    user.has_role?(:accountant)
  end
end
