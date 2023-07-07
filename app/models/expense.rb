class Expense < ApplicationRecord
  include AASM

  after_create :create_expense_trigger_actions

  has_many :aasm_logs, as: :aasm_logable, dependent: :destroy

  has_one :user_request, as: :requestable, dependent: :destroy

  has_many_attached :receipts

  enum :category, %i[none travel meal_entertainment training_development office_equipment employee_benefits miscellaneous], prefix: :category

  validates :date, :category, :amount, presence: true
  validates :category, exclusion: {in: ["none"], message: I18n.t("errors.not_allowing_none")}

  delegate :user, to: :user_request

  attr_accessor :user_id
  attr_accessor :actor_id

  aasm column: "aasm_state" do
    after_all_transitions :log_status_change

    state :created, initial: true
    state :validated_by_manager
    state :validated_by_hr
    state :paid
    state :back_to_modified
    state :rejected

    event :validate_by_manager do
      transitions from: [:created, :back_to_modified], to: :validated_by_manager, after: :validate_by_manager_trigger_actions
    end

    event :validate_by_hr do
      transitions from: :validated_by_manager, to: :validated_by_hr, after: :validate_by_hr_trigger_actions
    end

    event :pay do
      transitions from: :validated_by_hr, to: :paid, after: :pay_trigger_actions
    end

    event :back_to_modify do
      transitions from: [:created, :validated_by_manager, :validated_by_hr, :back_to_modified], to: :back_to_modified, after: :back_to_modify_trigger_actions
    end

    event :reject do
      transitions from: [:created, :validated_by_manager, :back_to_modified], to: :rejected, after: :reject_trigger_actions
    end
  end

  def create_user_request
    UserRequest.create(user_id: user_id, state: :pending, requestable: self)
  end

  def receipts=(attachables)
    attachables = Array(attachables).compact_blank

    return unless attachables.any?
    new_attachments = attachables.reject { |attachment| attachment_exists?(attachment) }

    return unless new_attachments.any?
    attachment_changes["receipts"] = ActiveStorage::Attached::Changes::CreateMany.new("receipts", self, receipts.blobs + new_attachments)
  end

  def available_next_states(user)
    policy = ExpensePolicy.new(self, user: user)
    case aasm_state
    when "created"
      policy.allowed_to?(:validate_by_manager?, self) ? [:validate_by_manager, :back_to_modify, :reject] : []
    when "validated_by_manager"
      policy.allowed_to?(:validate_by_hr?, self) ? [:validate_by_hr, :back_to_modify, :reject] : []
    when "validated_by_hr"
      policy.allowed_to?(:pay?, self) ? [:pay, :back_to_modify] : []
    when "back_to_modified"
      policy.allowed_to?(:back_to_modify?, self) ? [:validate_by_manager, :back_to_modify, :reject] : []
    else
      []
    end
  end

  # Actions

  def create_expense_trigger_actions
    create_user_request
    notify_manager
    AasmLog.create(aasm_logable: self, actor_id: user.id, to_state: "created")
  end

  def validate_by_manager_trigger_actions
    notify_hr
  end

  def validate_by_hr_trigger_actions
    notify_payer
  end

  def pay_trigger_actions
    notify_member
  end

  def back_to_modify_trigger_actions
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

  def notify_payer
    # TODO not yet implmented
  end

  def notify_member
    # TODO not yet implmented
  end

  private

  def attachment_exists?(attachment)
    receipts.blobs.any? { |blob| blob.filename.to_s == attachment.original_filename }
  end

  def log_status_change
    AasmLog.create(aasm_logable: self, actor_id: actor_id, from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event)
  end
end
