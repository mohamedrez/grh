class Option < ApplicationRecord
  belongs_to :question

  has_one :single_select_response, dependent: :destroy
  has_many :multiple_select_responses, dependent: :destroy

  validates :name, presence: true
end
