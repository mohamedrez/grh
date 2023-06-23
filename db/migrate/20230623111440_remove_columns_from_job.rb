class RemoveColumnsFromJob < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :application, :integer
    remove_column :jobs, :interview, :integer
  end
end
