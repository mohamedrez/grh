class MultipleSelectResponse < ApplicationRecord
  has_one :user_answer, as: :answerable, dependent: :destroy

  has_many :multiple_select_options, dependent: :destroy
  has_many :options, through: :multiple_select_options
end
