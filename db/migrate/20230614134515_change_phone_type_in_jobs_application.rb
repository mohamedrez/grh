class ChangePhoneTypeInJobsApplication < ActiveRecord::Migration[7.0]
  def change
    change_column :job_applications, :phone, :string
  end
end
