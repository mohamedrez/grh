class AddJobToJobApplication < ActiveRecord::Migration[7.0]
  def change
    add_reference :job_applications, :job, null: false, foreign_key: true
  end
end