class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.references :eventable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
