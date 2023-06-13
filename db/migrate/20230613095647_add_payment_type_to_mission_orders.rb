class AddPaymentTypeToMissionOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :mission_orders, :payment_type, :string
  end
end
