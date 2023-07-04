class QuestionAnswer < ApplicationRecord
  belongs_to :user_answer
  belongs_to :question
  belongs_to :answerable, polymorphic: true
end
