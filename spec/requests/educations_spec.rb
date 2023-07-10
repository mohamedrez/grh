require "rails_helper"

RSpec.describe "/educations", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:education) { create(:education, user_id: user.id) }

  let(:valid_attributes) do
    {
      school: "Harvard",
      country: :usa,
      city: "Boston",
      education_level: :bachelor,
      study_field: :software_engineering,
      start_date: "2018-01-01",
      end_date: "2022-12-31",
      still_on_this_course: false
    }
  end

  let(:invalid_attributes) do
    {
      school: "",
      city: "",
      start_date: "",
      end_date: ""
    }
  end

  before do
    sign_in user
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_education_url(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_education_path(user_id: user.id, id: education.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Education" do
        expect {
          post user_educations_url(user_id: user.id), params: {education: valid_attributes}
        }.to change(Education, :count).by(1)
      end

      before do
        post user_educations_url(user_id: user.id), params: {education: valid_attributes}
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("remove")
        expect(response.body).to include("append")
        expect(response.body).to include("education-list")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Education" do
        expect {
          post user_educations_url(user_id: user.id), params: {education: invalid_attributes}
        }.to change(Education, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post user_educations_url(user_id: user.id), params: {education: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "when the education is successfully updated" do
      before do
        patch user_education_path(user_id: user.id, id: education.id), params: {education: valid_attributes}
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the requested education" do
        education.reload
        expect(education.school).to eq("Harvard")
        expect(education.city).to eq("Boston")
        expect(education.country).to eq("usa")
        expect(education.education_level).to eq("bachelor")
        expect(education.start_date).to eq(Date.new(2018, 1 , 1))
        expect(education.end_date).to eq(Date.new(2022, 12 , 31))
        expect(education.still_on_this_course).to eq(false)
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

    context "when the education fails to update" do
      it "returns an unprocessable entity status" do
        patch user_education_path(user_id: user.id, id: education.id), params: {education: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete user_education_path(user_id: user.id, id: education.id)
    end

    it "destroys the education" do
      expect(Education.count).to eq(0)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_destroyed"))
    end
  end
end
