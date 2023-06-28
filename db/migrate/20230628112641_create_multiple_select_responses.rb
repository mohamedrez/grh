class CreateMultipleSelectResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :multiple_select_responses do |t|
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
