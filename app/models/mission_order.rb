class MissionOrder < ApplicationRecord
  after_create :create_user_request

  belongs_to :site
  has_one :user_request, as: :requestable, dependent: :destroy
  has_rich_text :description

  enum indemnity_type: {expense_report: 0, flat_rate: 1}
  enum accommodation: {apartment: 0, hotel: 1, other_accommodations: 2}
  enum mission_type: {project: 0, site: 1}
  enum transport_type: {plane: 0, train: 1, bus: 2, other_transport_types: 3}

  validates :title, :start_date, :end_date, :indemnity_type, :mission_type, :location, :transport_type, presence: true
  validates_comparison_of :end_date, greater_than_or_equal_to: :start_date
  validate :validate_indemnity_type

  delegate :user, to: :user_request

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  private

  def validate_indemnity_type
    return unless start_date.present? && end_date.present?

    duration = (end_date - start_date).to_i + 1

    if duration == 1 && indemnity_type == "flat_rate"
      errors.add(:indemnity_type, I18n.t("attributes.mission_order.errors.must_be_expense_report"))
    elsif duration > 15 && indemnity_type == "expense_report"
      errors.add(:indemnity_type, I18n.t("attributes.mission_order.errors.must_be_flat_rate"))
    end
  end
end
