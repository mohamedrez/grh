class AddAasmStateToJobApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :aasm_state, :string
  end
end
