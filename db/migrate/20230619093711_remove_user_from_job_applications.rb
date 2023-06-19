class RemoveUserFromJobApplications < ActiveRecord::Migration[7.0]
  def change
    remove_reference :job_applications, :user, null: false, foreign_key: true
  end
end
