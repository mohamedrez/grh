class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true

  def same_thread_comments
    Comments.where(commentable_id: commentable.id)
  end
end
