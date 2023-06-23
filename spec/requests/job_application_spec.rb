require 'rails_helper'

RSpec.describe "JobApplications", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:job) { create(:job, id: 1) }
  let(:job_application) { create(:job_application, job_id: job.id) }

  let(:valid_attributes) do
    {
      first_name: "FirstName",
      last_name: "LastName",
      job_id: job.id,
      email: "test@gmail.com",
      phone: "(602) 496-4636"
    }
  end

  let(:invalid_attributes) do
    {
      first_name: "FirstName",
      last_name: "",
      job_id: nil,
      email: "test@gmail.com",
      phone: "(602) 496-4636"
    }
  end

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get job_applications_path
      expect(response).to be_successful
    end

    it "redirects to job applications" do
      get job_job_applications_path(job_id: job.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_job_application_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_job_application_url(id: job_application.id)
      expect(response).to be_successful
    end
  end

  describe "GET /infos" do
    it "renders a successful response" do
      get job_application_infos_url(id: job_application.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Job Application" do
        expect {
          post job_applications_url, params: {job_application: valid_attributes}
        }.to change(JobApplication, :count).by(1)
      end

      before do
        post job_applications_url, params: {job_application: valid_attributes}
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Job Application" do
        expect {
          post job_applications_url, params: {job_application: invalid_attributes}
        }.to change(JobApplication, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post job_applications_url, params: {job_application: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch job_application_url(id: job_application.id), params: {job_application: valid_attributes}
      end

      it "updates the requested job application" do
        job_application.reload
        expect(job_application.first_name).to eq("FirstName")
        expect(job_application.last_name).to eq("LastName")
        expect(job_application.job_id).to eq(1)
        expect(job_application.email).to eq("test@gmail.com")
        expect(job_application.phone).to eq("(602) 496-4636")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch job_application_url(id: job_application.id), params: {job_application: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update_aasm_state' do
    context 'when aasm_state is "advanced_to_phone"' do
      it 'updates the AASM state to "advanced_to_phone" and redirects to the job application page' do
        patch update_aasm_state_job_application_path( id: job_application.id, aasm_state: 'advanced_to_phone')
        job_application.reload
        expect(job_application.aasm_state).to eq('advanced_to_phone')
        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'when aasm_state is "completed_phone"' do
      it 'updates the AASM state to "completed_phone" and redirects to the job application page' do
        job_application = create(:job_application, job_id: job.id, first_name: "FirstName", first_name: "FirstName",last_name: "LastName", email: "test@gmail.com", phone: "(602) 496-4636", aasm_state: "advanced_to_phone")
        patch update_aasm_state_job_application_path(id: job_application.id, aasm_state: 'completed_phone')
        job_application.reload
        expect(job_application.aasm_state).to eq('completed_phone')
        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'when aasm_state is "advanced_interview"' do
      it 'updates the AASM state to "advanced_interview" and redirects to the job application page' do
        job_application = create(:job_application, job_id: job.id, first_name: "FirstName", first_name: "FirstName",last_name: "LastName", email: "test@gmail.com", phone: "(602) 496-4636", aasm_state: "completed_phone")
        patch update_aasm_state_job_application_path(id: job_application.id, aasm_state: 'advanced_interview')
        job_application.reload
        expect(job_application.aasm_state).to eq('advanced_interview')
        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'when aasm_state is "completed_interview"' do
      it 'updates the AASM state to "completed_interview" and redirects to the job application page' do
        job_application = create(:job_application, job_id: job.id, first_name: "FirstName", first_name: "FirstName",last_name: "LastName", email: "test@gmail.com", phone: "(602) 496-4636", aasm_state: "advanced_interview")
        patch update_aasm_state_job_application_path(id: job_application.id, aasm_state: 'completed_interview')
        job_application.reload
        expect(job_application.aasm_state).to eq('completed_interview')
        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'when aasm_state is "disqualified"' do
      it 'updates the AASM state to "disqualified" and redirects to the job application page' do
        patch update_aasm_state_job_application_path( id: job_application.id, aasm_state: 'disqualified')
        job_application.reload
        expect(job_application.aasm_state).to eq('disqualified')
        expect(response).to redirect_to(job_application_path(job_application))
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      delete job_application_path(id: job_application.id)
    end
    
    it 'destroy the job application' do
      expect(JobApplication.count).to eq(0)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
    end
  end

  describe "DELETE /delete_resume" do
    before do
      job_application.resume.attach(io: File.open("#{Rails.root}/spec/fixtures/receipt.png"), filename: 'receipt.png', content_type: "image/png")
      resume = job_application.resume
      delete delete_resume_job_application_path(id: job_application.id, resume_id: resume.id)
    end

    it "delete the resume" do
      job_application.reload
      expect(job_application.resume.attached?).to eq(false)
    end

    it "redirects to the job_application" do
      expect(response).to redirect_to(job_application_path(job_application))
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.receipt_successfully_deleted"))
    end

    it 'returns a 302 response' do
      expect(response).to have_http_status(302)
    end
  end

end
