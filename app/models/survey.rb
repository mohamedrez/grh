class Survey < ApplicationRecord
  belongs_to :surveyable, polymorphic: true

  has_many :sections, dependent: :destroy

  validates :name, presence: true
end
