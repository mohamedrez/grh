require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:job) { create(:job, id: 1) }
  let(:job_application) { create(:job_application, job_id: job.id) }

  describe '#applicant_state' do
    it 'returns the correct hash for different states' do
      applied_state = job_application.applicant_state("applied")
      expect(applied_state).to eq({ next_state: "advanced_to_phone", title: I18n.t("attributes.job_application.aasm_states.advance_to_phone") })

      advanced_to_phone_state = job_application.applicant_state("advanced_to_phone")
      expect(advanced_to_phone_state).to eq({ next_state: "completed_phone", title: I18n.t("attributes.job_application.aasm_states.complete_phone") })

      completed_phone_state = job_application.applicant_state("completed_phone")
      expect(completed_phone_state).to eq({ next_state: "advanced_interview", title: I18n.t("attributes.job_application.aasm_states.advance_to_interview") })

      advanced_interview_state = job_application.applicant_state("advanced_interview")
      expect(advanced_interview_state).to eq({ next_state: "completed_interview", title: I18n.t("attributes.job_application.aasm_states.complete_interview") })

      completed_interview_state = job_application.applicant_state("completed_interview")
      expect(completed_interview_state).to eq({ result: I18n.t("attributes.job_application.aasm_states.qualified"), color: "green" })

      disqualified_state = job_application.applicant_state("disqualified")
      expect(disqualified_state).to eq({ result: I18n.t("attributes.job_application.aasm_states.disqualified"), color: "red" })
    end
  end
end
