class ChangeColumnsOfGoals < ActiveRecord::Migration[7.0]
  def change
    remove_column :goals, :start_date, :date
    remove_column :goals, :due_date, :date
    add_column :goals, :year, :integer
  end
end
