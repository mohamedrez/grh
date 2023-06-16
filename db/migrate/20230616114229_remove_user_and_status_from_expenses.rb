class RemoveUserAndStatusFromExpenses < ActiveRecord::Migration[7.0]
  def change
    remove_reference :expenses, :user, null: false, foreign_key: true
    remove_column :expenses, :status, :integer
  end
end
