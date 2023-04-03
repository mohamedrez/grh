class ChangeManagedByToNullTrueOnUserRequests < ActiveRecord::Migration[7.0]
  def change
    change_column_null :user_requests, :managed_by_id, true
  end
end
