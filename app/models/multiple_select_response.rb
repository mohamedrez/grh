class MultipleSelectResponse < ApplicationRecord
  has_one :user_answer, as: :answerable, dependent: :destroy
  belongs_to :option
end
