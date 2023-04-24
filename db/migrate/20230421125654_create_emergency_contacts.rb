class CreateEmergencyContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :emergency_contacts do |t|
      t.string :name
      t.integer :relationship
      t.string :phone
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
