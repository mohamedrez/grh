class AddStateToMissionOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :mission_orders, :state, :string
  end
end
