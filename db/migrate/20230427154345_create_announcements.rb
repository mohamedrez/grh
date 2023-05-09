class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.date :published_at

      t.timestamps
    end
  end
end
