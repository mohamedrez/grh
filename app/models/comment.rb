class Comment < ApplicationRecord
  include Wisper.model

  belongs_to :author, class_name: "User"
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true

  def same_thread_comments
    Comment.where(commentable_id: commentable.id)
      .where.not(id: id)
  end

  def one_comment?
    same_thread_comments.count == 0
  end
end
