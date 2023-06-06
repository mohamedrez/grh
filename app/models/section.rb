class Section < ApplicationRecord
  has_many :review_sections, dependent: :destroy
  has_many :reviews, through: :review_sections

  has_many :questions, dependent: :destroy

  validates :name, :description, :section_type, presence: true

  enum section_type: {strengths_opportunities: 0, goals: 1}
end
