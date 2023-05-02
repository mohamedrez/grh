class AddLocationToExperiences < ActiveRecord::Migration[7.0]
  def change
    add_column :experiences, :country, :integer
    add_column :experiences, :city, :string
  end
end
