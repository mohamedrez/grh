class CreateEducations < ActiveRecord::Migration[7.0]
  def change
    create_table :educations do |t|
      t.string :school
      t.integer :country
      t.string :city
      t.integer :education_level
      t.integer :study_field
      t.date :start_date
      t.date :end_date
      t.boolean :still_on_this_course
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
