class ExpensePolicy < ApplicationPolicy
  def show?
    user.has_any_role?([:hr, :admin]) ||
      (user.id == record.user.id) ||
      (user.id == record.user.manager_id)
  end

  def approve?
    user.has_any_role?([:hr, :admin]) ||
      user.id == record.user.manager_id
  end

  def validate_expense_by_manager?
    true
  end

  def validate_expense_by_hr?
    true
  end

  def pay_expense?
    true
  end
end
