class CreateQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :question_answers do |t|
      t.references :user_answer, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answerable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
