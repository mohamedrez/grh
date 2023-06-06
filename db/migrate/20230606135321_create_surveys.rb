class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.string :name
      t.references :surveyable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
