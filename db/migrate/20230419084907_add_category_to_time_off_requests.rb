class AddCategoryToTimeOffRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :time_off_requests, :category, :integer
  end
end
