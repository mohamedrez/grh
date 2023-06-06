class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.text :description
      t.integer :section_type

      t.timestamps
    end
  end
end
