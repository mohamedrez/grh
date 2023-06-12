class MissionOrder < ApplicationRecord
  include AASM

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

  attr_accessor :actor_id

  # mission_order.actor_id = current_user.id
  # mission_order.create!

  aasm do
    after_all_transitions :log_status_change

    state :none, initial: true
    state :created
    state :validated_by_manager
    state :validated_by_hr
    state :paid

    event :create do
      transitions from: :none, to: :created, after: :create_mission_order_trigger_actions
    end

    event :validate_mission_order_by_manager do
      transitions from: :draft, to: :submitted
    end
  end

  attr_accessor :user_id

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def create_mission_order_trigger_actions
    create_user_request
    notify_manager
  end

  def notify_manager
    # TODO not yet implmented
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

  def log_status_change
    # TODO creates log_event
    # aasm_log.create(class_name: self.class.name, from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event)
  end
end
