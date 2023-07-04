class CreateMultipleSelectOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :multiple_select_options do |t|
      t.references :multiple_select_response, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
