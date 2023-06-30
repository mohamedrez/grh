class TextResponse < ApplicationRecord
  validates :content, presence: true

  has_one :user_answer, as: :answerable, dependent: :destroy
end
