class AddAasmStateToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :aasm_state, :string
  end
end
