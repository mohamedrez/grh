class AddUserIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :user_id, :integer, foreign_key: true, dependent: :destroy
    add_index :events, :user_id
  end
end
