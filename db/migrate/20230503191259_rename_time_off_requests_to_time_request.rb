class RenameTimeOffRequestsToTimeRequest < ActiveRecord::Migration[7.0]
  def change
    rename_table :time_off_requests, :time_requests
  end
end
