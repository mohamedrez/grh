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
end
