class TextResponse < ApplicationRecord
  has_one :user_answer, as: :answerable, dependent: :destroy
end
