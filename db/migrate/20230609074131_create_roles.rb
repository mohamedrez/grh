class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.integer :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
