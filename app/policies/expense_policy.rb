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
end
