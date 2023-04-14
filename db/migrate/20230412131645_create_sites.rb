class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :code
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
