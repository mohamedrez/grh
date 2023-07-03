class CreateUserAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_answers do |t|
      t.references :review, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
