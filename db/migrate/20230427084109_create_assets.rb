class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.integer :category
      t.text :description
      t.string :serial
      t.date :date_assigned
      t.date :date_returned
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
