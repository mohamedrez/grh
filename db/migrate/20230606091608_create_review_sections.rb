class CreateReviewSections < ActiveRecord::Migration[7.0]
  def change
    create_table :review_sections do |t|
      t.references :review, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
