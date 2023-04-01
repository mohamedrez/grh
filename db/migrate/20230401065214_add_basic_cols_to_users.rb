class AddBasicColsToUsers < ActiveRecord::Migration[7.0]
  change_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.date :birthdate
    t.date :start_date
    t.date :end_date
    t.integer :gender
    t.integer :marital_status
  end
end
