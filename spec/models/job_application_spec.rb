require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let(:job) { create(:job, id: 1) }
  let(:job_application) { create(:job_application, job_id: job.id) }

  describe '#advance_to_state' do
    it 'returns the correct hash for different states' do
      applied_state = job_application.advance_to_state("applied")
      expect(applied_state).to eq({ next_state: "advanced_to_phone", title: I18n.t("attributes.job_application.aasm_states.advance_to_phone"), class_css: "yellow-badge"})

      advanced_to_phone_state = job_application.advance_to_state("advanced_to_phone")
      expect(advanced_to_phone_state).to eq({ next_state: "completed_phone", title: I18n.t("attributes.job_application.aasm_states.complete_phone"), class_css: "yellow-badge"})

      completed_phone_state = job_application.advance_to_state("completed_phone")
      expect(completed_phone_state).to eq({ next_state: "advanced_interview", title: I18n.t("attributes.job_application.aasm_states.advance_to_interview"), class_css: "yellow-badge"})

      advanced_interview_state = job_application.advance_to_state("advanced_interview")
      expect(advanced_interview_state).to eq({ next_state: "completed_interview", title: I18n.t("attributes.job_application.aasm_states.complete_interview"), class_css: "yellow-badge"})

      completed_interview_state = job_application.advance_to_state("completed_interview")
      expect(completed_interview_state).to eq({ result: I18n.t("attributes.job_application.aasm_states.qualified"), class_css: "green-badge" })

      disqualified_state = job_application.advance_to_state("disqualified")
      expect(disqualified_state).to eq({ result: I18n.t("attributes.job_application.aasm_states.disqualified"), class_css: "red-badge" })
    end

    context "when translate_state method is called" do
      it "returns the correct translated state for 'applied'" do
        state = "applied"
        translated_state = subject.translate_state(state)
        expect(translated_state).to eq(I18n.t("attributes.job_application.aasm_states.applied"))
      end
      
      it "returns the correct translated state for 'advanced_to_phone'" do
        state = "advanced_to_phone"
        translated_state = subject.translate_state(state)
        expect(translated_state).to eq(I18n.t("attributes.job_application.aasm_states.advanced_to_phone", by: ""))
      end

      it "returns the correct translated state for 'completed_phone'" do
        state = "completed_phone"
        translated_state = subject.translate_state(state)
        expect(translated_state).to eq(I18n.t("attributes.job_application.aasm_states.completed_phone", by: ""))
      end

      it "returns the correct translated state for 'advanced_interview'" do
        state = "advanced_interview"
        translated_state = subject.translate_state(state)
        expect(translated_state).to eq(I18n.t("attributes.job_application.aasm_states.advanced_to_interview", by: ""))
      end

      it "returns the correct translated state for 'completed_interview'" do
        state = "completed_interview"
        translated_state = subject.translate_state(state)
        expect(translated_state).to eq(I18n.t("attributes.job_application.aasm_states.qualified"))
      end
      
      it "returns the correct translated state for 'disqualified'" do
        state = "disqualified"
        translated_state = subject.translate_state(state)
        expect(translated_state).to eq(I18n.t("attributes.job_application.aasm_states.disqualified"))
      end
    end

    context "#job_application_route_handler" do
      it "returns the correct URLs when job_id is present" do
        job_id = 123
        job_application_id = 456
        next_state = "some_state"
        
        urls = subject.job_application_route_handler(job_id, job_application_id, next_state)
        
        expect(urls[:update_aasm_state]).to eq("/jobs/#{job_id}/job_applications/#{job_application_id}/update_aasm_state?aasm_state=#{next_state}")
        expect(urls[:disqualified]).to eq("/jobs/#{job_id}/job_applications/#{job_application_id}/update_aasm_state?aasm_state=disqualified")
      end
      
      it "returns the correct URLs when job_id is not present" do
        job_id = nil
        job_application_id = 456
        next_state = "some_state"
        
        urls = subject.job_application_route_handler(job_id, job_application_id, next_state)
        
        expect(urls[:update_aasm_state]).to eq("/job_applications/#{job_application_id}/update_aasm_state?aasm_state=#{next_state}")
        expect(urls[:disqualified]).to eq("/job_applications/#{job_application_id}/update_aasm_state?aasm_state=disqualified")
      end
    end
  end
end
