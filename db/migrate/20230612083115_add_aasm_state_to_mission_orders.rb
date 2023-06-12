class AddAasmStateToMissionOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :mission_orders, :aasm_state, :string
  end
end
