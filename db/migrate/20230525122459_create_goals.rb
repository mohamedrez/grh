class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.string :title
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.integer :status
      t.date :start_date
      t.date :due_date
      t.boolean :archived, default: false
      t.integer :level
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.text :end_goal_description

      t.timestamps
    end
  end
end
