class AddBasicColsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :date
    add_column :users, :entry_date, :date
    add_column :users, :departure_date, :date
  end
end
