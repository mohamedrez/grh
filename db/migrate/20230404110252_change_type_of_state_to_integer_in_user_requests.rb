class ChangeTypeOfStateToIntegerInUserRequests < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :user_requests, :state, :integer
      end

      dir.down do
        change_column :user_requests, :state, :string
      end
    end
  end
end
