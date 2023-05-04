class RemoveEventsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :events
  end
end
