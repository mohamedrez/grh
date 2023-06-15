class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :source
      t.string :link
      t.string :note

      t.timestamps
    end
  end
end
