class MissionOrder < ApplicationRecord
  include AASM

  after_create :create_mission_order_trigger_actions

  belongs_to :site

  has_one :aasm_log, as: :aasm_logable, dependent: :destroy
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
  attr_accessor :actor_id

  aasm column: "aasm_state" do
    after_all_transitions :log_status_change

    state :created, initial: true
    state :validated_by_manager
    state :validated_by_hr
    state :paid
    state :cancelled

    event :validate_mission_order_by_manager do
      transitions from: :created, to: :validated_by_manager, after: :validate_mission_order_by_manager_trigger_actions
    end

    event :validate_mission_order_by_hr do
      transitions from: :validated_by_manager, to: :validated_by_hr, after: :validate_mission_order_by_hr_trigger_actions
    end

    event :pay_mission_order do
      transitions from: :validated_by_hr, to: :paid, after: :pay_mission_order_trigger_actions
    end

    event :cancel_mission_order do
      transitions from: [:created, :validated_by_manager, :validated_by_hr], to: :cancelled, after: :cancel_mission_order_trigger_actions
    end
  end

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  # Actions

  def create_mission_order_trigger_actions
    create_user_request
    notify_manager
  end

  def validate_mission_order_by_manager_trigger_actions
    notify_hr
  end

  def validate_mission_order_by_hr_trigger_actions
    if site?
      notify_accountant
    elsif project?
      notify_holding_treasury
    end
  end

  def pay_mission_order_trigger_actions
    notify_member
  end

  def cancel_mission_order_trigger_actions
    notify_member
  end

  # Notifying

  def notify_manager
    # TODO not yet implmented
  end

  def notify_hr
    # TODO not yet implmented
  end

  def notify_accountant
    # TODO not yet implmented
  end

  def notify_holding_treasury
    # TODO not yet implmented
  end

  def notify_member
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
    AasmLog.create(aasm_logable: self, actor_id: actor_id, from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event)
  end
end
