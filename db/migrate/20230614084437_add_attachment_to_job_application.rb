class AddAttachmentToJobApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :job_applications, :attachment, :blob
  end
end
