class AddBasicColsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :start_date, :date
    add_column :users, :end_date, :date
    add_column :users, :gender, :integer
    add_column :users, :marital_status, :integer
    add_reference :users, :manager, foreign_key: {to_table: :users}
  end
end
