class CreateMultipleSelectResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :multiple_select_responses do |t|

      t.timestamps
    end
  end
end
