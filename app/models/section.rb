class Section < ApplicationRecord
  belongs_to :review

  has_many :questions, dependent: :destroy

  validates :name, :description, :section_type, presence: true

  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  enum section_type: {strengths_opportunities: 0, goals: 1}
end
