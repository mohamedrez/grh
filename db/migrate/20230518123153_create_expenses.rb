class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :category
      t.text :description
      t.float :amount
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
