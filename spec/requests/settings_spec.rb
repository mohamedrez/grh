require "rails_helper"

RSpec.describe "Settings", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:valid_attributes) do
    {
      first_name: "James",
      last_name: "Clear",
      email: "me@test.com",
      job_title: "information_technology"
    }
  end
  let(:invalid_attributes) do
    {
      first_name: "",
      last_name: "",
      email: "me@test.com",
      job_title: "information_technology"
    }
  end

  before do
    sign_in user
  end

  describe "GET #edit" do
    it "renders a successful response" do
      get "/users/#{user.id}/settings"
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the requested settings" do
        patch "/users/#{user.id}/settings", params: {user: valid_attributes}
        user.reload
        expect(user.first_name).to eq("James")
        expect(user.last_name).to eq("Clear")
        expect(user.job_title).to eq("information_technology")
      end

      it "redirects to the user" do
        patch "/users/#{user.id}/settings", params: {user: valid_attributes}
        user.reload
        expect(response).to redirect_to(user_settings_url(user_id: user.id))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}/settings", params: {user: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
