class AddColsToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :ceiling, :string
    add_column :goals, :target, :string
    add_column :goals, :floor, :string
  end
end
