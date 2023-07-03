class JobApplication < ApplicationRecord
  include AASM

  after_create :create_job_application_trigger_actions

  belongs_to :job
  has_many :aasm_logs, as: :aasm_logable, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
  validates :email, presence: true, format: {with: /\A[\w+\-.]+@[a-z\d\ -]+(\.[a-z\d\ -]+)*\.[a-z]+\z/i}
  has_one_attached :resume, dependent: :destroy

  attr_accessor :actor_id

  aasm column: "aasm_state" do
    after_all_transitions :log_status_change

    state :applied, initial: true
    state :advanced_to_phone
    state :completed_phone
    state :advanced_interview
    state :completed_interview
    state :disqualified

    event :advance_job_application_to_phone_screening do
      transitions from: :applied, to: :advanced_to_phone, after: :advanced_to_phone_screening_trigger_actions
    end

    event :complete_job_application_phone_screening do
      transitions from: :advanced_to_phone, to: :completed_phone, after: :completed_phone_screening_trigger_actions
    end

    event :advance_job_application_to_interview do
      transitions from: :completed_phone, to: :advanced_interview, after: :advanced_to_interview_trigger_actions
    end

    event :complete_job_application_to_interview do
      transitions from: :advanced_interview, to: :completed_interview, after: :completed_to_interview_trigger_actions
    end

    event :disqualify_applicant do
      transitions from: [:applied, :advanced_to_phone, :completed_phone, :advanced_interview, :completed_interview], to: :disqualified, after: :disqualify_applicant_trigger_actions
    end
  end

  # Methods

  def applicant_state(state)
    case state
    when "applied"
      {next_state: "advanced_to_phone", title: I18n.t("attributes.job_application.aasm_states.advance_to_phone"), color: "yellow"}
    when "advanced_to_phone"
      {next_state: "completed_phone", title: I18n.t("attributes.job_application.aasm_states.complete_phone"), color: "yellow"}
    when "completed_phone"
      {next_state: "advanced_interview", title: I18n.t("attributes.job_application.aasm_states.advance_to_interview"), color: "yellow"}
    when "advanced_interview"
      {next_state: "completed_interview", title: I18n.t("attributes.job_application.aasm_states.complete_interview"), color: "yellow"}
    when "completed_interview"
      {result: I18n.t("attributes.job_application.aasm_states.qualified"), color: "green"}
    when "disqualified"
      {result: I18n.t("attributes.job_application.aasm_states.disqualified"), color: "red"}
    end
  end

  def applicant_advanced_by(to_state)
    case to_state
    when "advanced_to_phone"
      I18n.t("attributes.job_application.aasm_states.advanced_to_phone", by: " by")
    when "completed_phone"
      I18n.t("attributes.job_application.aasm_states.completed_phone", by: " by")
    when "advanced_interview"
      I18n.t("attributes.job_application.aasm_states.advanced_to_interview", by: " by")
    when "completed_interview"
      I18n.t("attributes.job_application.aasm_states.completed_interview", by: " by")
    when "disqualified"
      I18n.t("attributes.job_application.aasm_states.disqualified")
    end
  end

  def current_state(state)
    case state
    when "applied"
      I18n.t("attributes.job_application.aasm_states.applied")
    when "advanced_to_phone"
      I18n.t("attributes.job_application.aasm_states.advanced_to_phone", by: "")
    when "completed_phone"
      I18n.t("attributes.job_application.aasm_states.completed_phone", by: "")
    when "advanced_interview"
      I18n.t("attributes.job_application.aasm_states.advanced_to_interview", by: "")
    when "completed_interview"
      I18n.t("attributes.job_application.aasm_states.qualified")
    when "disqualified"
      I18n.t("attributes.job_application.aasm_states.disqualified")
    end
  end

  def job_application_handler(job_id, job_application_id, next_state = "")
    if job_id.present?
      {
        update_aasm_state: "/jobs/#{job_id}/job_applications/#{job_application_id}/update_aasm_state?aasm_state=#{next_state}",
        disqualified: "/jobs/#{job_id}/job_applications/#{job_application_id}/update_aasm_state?aasm_state=disqualified",
        applicant: "/jobs/#{job_id}/job_applications/#{job_application_id}",
        edit_applicant: "/jobs/#{job_id}/job_applications/#{job_application_id}/edit"
      }
    else
      {
        update_aasm_state: "/job_applications/#{job_application_id}/update_aasm_state?aasm_state=#{next_state}",
        disqualified: "/job_applications/#{job_application_id}/update_aasm_state?aasm_state=disqualified",
        applicant: "job_applications/#{job_application_id}",
        edit_applicant: "job_applications/#{job_application_id}/edit"
      }
    end
  end
  # Actions

  def create_job_application_trigger_actions
    # create_user_request
    notify_manager
  end

  def advanced_to_phone_screening_trigger_actions
    notify_applicant
  end

  def completed_phone_screening_trigger_actions
    notify_applicant
  end

  def advanced_to_interview_trigger_actions
    notify_applicant
  end

  def completed_to_interview_trigger_actions
    notify_applicant
  end

  def disqualify_applicant_trigger_actions
    notify_applicant
  end

  # Notifying

  def notify_manager
    # TODO not yet implmented
  end

  def notify_hr
    # TODO not yet implmented
  end

  def notify_applicant
    # TODO not yet implmented
  end

  private

  def log_status_change
    AasmLog.create(aasm_logable: self, actor_id: actor_id, from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event)
  end
end
