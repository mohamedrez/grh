class ModifySitesTable < ActiveRecord::Migration[7.0]
  def up
    add_column :sites, :code, :string
    add_column :sites, :address, :string
    add_column :sites, :phone, :string
    change_column :sites, :name, :string
    remove_reference :sites, :user, foreign_key: true
  end

  def down
    add_reference :sites, :user, foreign_key: true
    remove_column :sites, :code, :string
    remove_column :sites, :address, :string
    remove_column :sites, :phone, :string
    change_column :sites, :name, :integer
  end
end
