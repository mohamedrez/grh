require 'rails_helper'

RSpec.describe "Jobs", type: :request do
    let(:user) {create(:user)}
    let(:job) {create(:job)}

    let(:valid_attributes) do {
        title: "Test Job", 
        location: "Test Location",
        overview: "Test Overview",
        min_salary: 1,
        max_salary: 2,
        unit: "hour"
    }
    end
    let(:invalid_attributes) do {
        title: "", 
        location: "",
        overview: "",
        max_salary: nil,
        min_salary: nil,
        unit: ""
    }
    end

    before do
        sign_in user

    end

    describe "GET /index" do
        it "renders a successful response" do
            get jobs_url(jub_id: job.id)
            expect(response).to be_successful
        end
    end

    describe "GET /show" do
        it "renders a successful response" do
            get job_path(id: job.id)
            expect(response).to be_successful
        end
    end

    describe "GET /new" do
    it "renders a successful response" do
      get new_job_path()
      expect(response).to be_successful
        end
    end

    describe "POST /create" do
        context "With valid params" do
            it "creates a new job" do
            expect {
                post jobs_url, params: { job: valid_attributes }
            }.to change(Job, :count).by(1)
            end
            it "redirects to jobs index page" do
                post jobs_url, params: { job: valid_attributes }
                expect(response).to redirect_to(jobs_url)
                expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
            end
        end
        context "With invalid params" do
            it "does not create a new Job" do
                expect {
                    post jobs_url, params: { job: invalid_attributes }
                }.to change(Job, :count).by(0)
            end
            it "responds with 422 unprocessable entity" do
                post jobs_url, params: { job: invalid_attributes } 
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "GET /edit" do
        it "renders a successful response" do
            get "/jobs/#{job.id}/edit"
            expect(response).to be_successful
        end
    end

    describe "PATH /update" do
        context "with valid parameters" do
            it "updates the requested Job" do
                patch "/jobs/#{job.id}", params: {job: valid_attributes}
                job.reload

                expect(job.title).to eq("Test Job")
                expect(job.location).to eq("Test Location")
                expect(job.overview).to eq("Test Overview")
                expect(job.min_salary).to eq(1)
                expect(job.max_salary).to eq(2)
                expect(job.unit).to eq("hour")
            end
        end
        context "with invalid parameters" do
            it "does not update the requested Job" do
                patch "/jobs/#{job.id}", params: {job: invalid_attributes}
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "DELETE /destroy" do
        before do
            delete job_path(id: job.id)
        end
          
        it 'destroy the job' do
            expect(Job.count).to eq(0)
        end
    
        it 'sets the flash notice' do
            expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
        end
    end
    
end