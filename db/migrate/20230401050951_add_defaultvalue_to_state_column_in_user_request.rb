class AddDefaultvalueToStateColumnInUserRequest < ActiveRecord::Migration[7.0]
  def change
    change_column_default :user_requests, :state, from: nil, to: "pending"
  end
end
