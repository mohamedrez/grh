class AddColumnsToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :first_name, :string
    add_column :job_applications, :last_name, :string
    add_column :job_applications, :phone, :string
    add_column :job_applications, :email, :string
    add_column :job_applications, :source, :string
    add_column :job_applications, :link, :string
    add_column :job_applications, :note, :string
  end
end
