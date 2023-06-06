class Question < ApplicationRecord
  belongs_to :section

  validates :title, :response_type, presence: true

  enum response_type: {textbox: 0, single_select: 1, multiple_select: 2}
end
