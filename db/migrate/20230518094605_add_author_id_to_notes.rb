class AddAuthorIdToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :author_id, :bigint
    add_index :notes, :author_id
  end
end
