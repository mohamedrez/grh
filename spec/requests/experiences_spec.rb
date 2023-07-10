require "rails_helper"

RSpec.describe "/experiences", type: :request do
  let(:user) { create(:user) }
  let(:experience) { create(:experience, user_id: user.id) }

  let(:valid_attributes) do
    {
      job_title: "Software Developer",
      company_name: "Acme Inc.",
      employment_type: :contractor,
      start_date: "2022-01-01",
      end_date: "2022-12-31",
      city: "New City",
      country: :usa,
      work_description: "Work description text"
    }
  end

  let(:invalid_attributes) do
    {
      job_title: "",
      company_name: "",
      start_date: "",
      end_date: "",
      city: "",
      work_description: "Worked on a variety of projects using Ruby on Rails and React"
    }
  end

  before do
    sign_in user
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_experience_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_experience_path(user_id: user.id, id: experience.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Experience" do
        expect {
          post user_experiences_path(user_id: user.id), params: {experience: valid_attributes}
        }.to change(Experience, :count).by(1)
      end

      before do
        post user_experiences_path(user_id: user.id), params: {experience: valid_attributes}
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("remove")
        expect(response.body).to include("append")
        expect(response.body).to include("experience-list")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      before do 
        post user_experiences_path(user_id: user.id), params: {experience: invalid_attributes}
      end

      it "does not create a new Experience" do
        expect(Experience.count).to eq(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "when the experience is successfully updated" do
      before do
        patch user_experience_path(user_id: user.id, id: experience.id), params: {experience: valid_attributes}
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the requested experience" do
        experience.reload
        expect(experience.job_title).to eq("Software Developer")
        expect(experience.company_name).to eq("Acme Inc.")
        expect(experience.employment_type).to eq("contractor")
        expect(experience.start_date).to eq(Date.new(2022, 1, 1))
        expect(experience.end_date).to eq(Date.new(2022, 12, 31))
        expect(experience.city).to eq("New City")
        expect(experience.country).to eq("usa")
        expect(experience.work_description).to eq("Work description text")
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end
    end

    context "when the experience fails to update" do
      it "returns an unprocessable entity status" do
        patch user_experience_path(user_id: user.id, id: experience.id), params: {experience: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete user_experience_path(user_id: user.id, id: experience.id)
    end

    it "destroys the experience" do
      expect(Experience.count).to eq(0)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_destroyed"))
    end
  end
end
