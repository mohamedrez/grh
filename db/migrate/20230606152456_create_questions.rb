class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :title
      t.integer :question_type
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
