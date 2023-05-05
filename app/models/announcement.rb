class Announcement < ApplicationRecord
  validates :title, :status, :published_at, presence: true
  belongs_to :user
  has_rich_text :content
  enum :status, %i[draft published]
end
