class Question < ApplicationRecord
  belongs_to :section

  has_many :options, dependent: :destroy

  validates :name, :question_type, presence: true

  accepts_nested_attributes_for :options, allow_destroy: true

  enum question_type: {textbox: 0, single_select: 1, multiple_select: 2}
end
