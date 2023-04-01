class RemoveUserFromTimeOffRequests < ActiveRecord::Migration[7.0]
  def change
    remove_column :time_off_requests, :user_id, :integer
  end
end
