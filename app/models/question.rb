class Question < ApplicationRecord
  belongs_to :section

  has_many :options, dependent: :destroy

  validates :title, :response_type, presence: true

  accepts_nested_attributes_for :options

  enum response_type: {textbox: 0, single_select: 1, multiple_select: 2}
end
