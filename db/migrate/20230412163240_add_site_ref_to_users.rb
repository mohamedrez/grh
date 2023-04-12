class AddSiteRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :site, null: false, foreign_key: true
  end
end
