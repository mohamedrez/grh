class MissionOrderPolicy < ApplicationPolicy
  # See https://actionpolicy.evilmartians.io/#/writing_policies
  #
  # def index?
  #   true
  # end
  #
  # def update?
  #   # here we can access our context and record
  #   user.admin? || (user.id == record.user_id)
  # end

  # Scoping
  # See https://actionpolicy.evilmartians.io/#/scoping
  #
  relation_scope do |relation|
    next relation if user.has_any_role?([:hr, :admin])

    user_request_ids = relation.map(&:user_request).pluck(:id)
    UserRequest.joins(:user)
      .where(id: user_request_ids, users: {manager_id: user.id})
  end
end
