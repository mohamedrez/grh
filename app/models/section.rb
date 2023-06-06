class Section < ApplicationRecord
  belongs_to :survey

  validates :name, :description, :section_type, presence: true

  enum section_type: {strengths_opportunities: 0, goals: 1}
end
