require "rails_helper"

RSpec.describe "/educations", type: :request do
  let(:admin_user) { create(:user, admin: true) }
  let(:education) { create(:education, user_id: admin_user.id) }

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
    sign_in admin_user
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_experience_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Education" do
        expect {
          post user_educations_url(user_id: admin_user.id), params: {education: valid_attributes}
        }.to change(Education, :count).by(1)
      end

      before do
        post user_educations_url(user_id: admin_user.id), params: {education: valid_attributes}
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("append")
        expect(response.body).to include("educations")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Education" do
        expect {
          post user_educations_url(user_id: admin_user.id), params: {education: invalid_attributes}
        }.to change(Education, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post user_educations_url(user_id: admin_user.id), params: {education: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
