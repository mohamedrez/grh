class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :job_title, :integer
    add_column :users, :children_number, :integer
    add_column :users, :cin, :string
    add_column :users, :service, :integer
    add_column :users, :joining_date, :date
    add_column :users, :contract, :integer
    add_column :users, :category, :integer
    add_column :users, :cnss_number, :string
    add_column :users, :employee_number, :string
    add_column :users, :brut_salary, :integer
    add_column :users, :net_salary, :integer
    add_column :users, :cnss_contribution, :integer
    add_column :users, :retirement_contribution, :integer
    add_column :users, :pto_number, :integer, default: 21
  end
end
