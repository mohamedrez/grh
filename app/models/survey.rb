class Survey < ApplicationRecord
  belongs_to :surveyable, polymorphic: true

  has_many :section, dependent: :destroy

  validates :name, presence: true
end
