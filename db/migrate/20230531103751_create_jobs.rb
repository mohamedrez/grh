class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.integer :job_type
      t.string :location
      t.boolean :remote, default: false, null: false
      t.string :overview
      t.integer :min_salary
      t.integer :max_salary
      t.integer :unit
      t.integer :status, default: 0
      # For future usage
      t.integer :application, default: 0
      t.integer :interview, default: 0

      t.timestamps
    end
  end
end
