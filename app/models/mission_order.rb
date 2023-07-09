class MissionOrder < ApplicationRecord
  include AASM

  after_create :create_mission_order_trigger_actions

  belongs_to :site

  has_many :aasm_logs, as: :aasm_logable, dependent: :destroy

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
    state :paid_by_accountant
    state :paid_by_holding_treasury
    state :rejected

    event :validate_by_manager do
      transitions from: :created, to: :validated_by_manager, after: :validate_by_manager_trigger_actions
    end

    event :validate_by_hr do
      transitions from: :validated_by_manager, to: :validated_by_hr, after: :validate_by_hr_trigger_actions
    end

    event :pay_by_accountant do
      transitions from: :validated_by_hr, to: :paid_by_accountant, after: :pay_trigger_actions
    end

    event :pay_by_holding_treasury do
      transitions from: :validated_by_hr, to: :paid_by_holding_treasury, after: :pay_trigger_actions
    end

    event :reject do
      transitions from: [:created, :validated_by_manager, :validated_by_hr], to: :rejected, after: :reject_trigger_actions
    end
  end

  def self.payment_types
    {"cash" => 0, "bank_transfer" => 1, "check" => 2, "binatna_recharge" => 3}
  end

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def available_next_state(user)
    policy = MissionOrderPolicy.new(self, user: user)
    case aasm_state
    when "created"
      policy.allowed_to?(:validate_by_manager?, self) ? :validate_by_manager : ""
    when "validated_by_manager"
      policy.allowed_to?(:validate_by_hr?, self) ? :validate_by_hr : ""
    when "validated_by_hr"
      if site?
        policy.allowed_to?(:pay?, self) ? :pay_by_accountant : ""
      elsif project?
        policy.allowed_to?(:pay?, self) ? :pay_by_holding_treasury : ""
      end
    end
  end

  # Actions

  def create_mission_order_trigger_actions
    create_user_request
    notify_manager
    AasmLog.create(aasm_logable: self, actor_id: user.id, to_state: "created")
  end

  def validate_by_manager_trigger_actions
    notify_hr
  end

  def validate_by_hr_trigger_actions
    if site?
      notify_accountant
    elsif project?
      notify_holding_treasury
    end
  end

  def pay_trigger_actions
    notify_member
  end

  def reject_trigger_actions
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
