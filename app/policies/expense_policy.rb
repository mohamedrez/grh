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
    user.has_any_role?([:hr, :hr_site_manager])
  end

  def pay?
    user.has_any_role?([:accountant, :accountant_site_manager])
  end

  def back_to_modify?
    validate_by_manager? || validate_by_hr? || pay?
  end
end
