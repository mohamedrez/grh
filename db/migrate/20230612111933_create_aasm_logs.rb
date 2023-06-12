class CreateAasmLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :aasm_logs do |t|
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.string :from_state
      t.string :to_state
      t.string :event
      t.references :aasm_logable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
