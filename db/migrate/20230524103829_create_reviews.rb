class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0
      t.integer :review_type

      t.timestamps
    end
  end
end
