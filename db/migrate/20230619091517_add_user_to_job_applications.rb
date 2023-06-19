class AddUserToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_reference :job_applications, :user, null: false, foreign_key: true
  end
end
