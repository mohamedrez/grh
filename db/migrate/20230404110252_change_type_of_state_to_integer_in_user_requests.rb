class ChangeTypeOfStateToIntegerInUserRequests < ActiveRecord::Migration[7.0]
  def change
    change_column :user_requests, :state, :integer
  end
end
