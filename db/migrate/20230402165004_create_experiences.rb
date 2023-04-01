class CreateExperiences < ActiveRecord::Migration[7.0]
  def change
    create_table :experiences do |t|
      t.string :job_title
      t.string :company_name
      t.integer :employment_type
      t.date :start_date
      t.date :end_date
      t.text :work_description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
