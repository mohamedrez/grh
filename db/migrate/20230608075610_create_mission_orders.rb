class CreateMissionOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :mission_orders do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.integer :indemnity_type
      t.integer :accommodation
      t.integer :mission_type
      t.string :location
      t.references :site, null: false, foreign_key: true
      t.integer :transport_means

      t.timestamps
    end
  end
end
