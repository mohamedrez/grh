class AddSiteRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :site, foreign_key: true
  end
end
