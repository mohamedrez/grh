class CreateUserRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :user_requests do |t|
      t.string :state
      t.references :user, null: false, foreign_key: true
      t.references :managed_by, null: false, foreign_key: {to_table: "users"}
      t.references :requestable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
