class ExpensePolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies

  def show?
    user.has_any_role?([:hr, :admin]) ||
      (user.id == record.user_id) ||
      (user.id == record.user.manager_id)
  end

  def approve?
    user.has_any_role?([:hr, :admin]) ||
      user.id == record.user.manager_id
  end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping

  relation_scope do |relation|
    next relation if user.has_any_role?([:hr, :admin])

    ids = UserRequest.joins(:user)
      .where(users: {manager_id: user.id})
      .where(requestable_type: "Expense")
      .pluck(:requestable_id)

    relation.where(id: ids)
  end
end
