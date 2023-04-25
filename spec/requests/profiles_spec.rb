require "rails_helper"

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:valid_attributes) do
    {
      email: "me@test.com",
      username: "mest",
      learning_goal: "i wanna be a senior RoR"
    }
  end

  before do
    sign_in user
  end

  describe "GET #edit" do
    it "renders a successful response" do
      get "/users/#{user.id}/profile"
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    it "updates the requested profile" do
      patch "/users/#{user.id}/profile", params: {user: valid_attributes}
      user.reload
      expect(user.username).to eq("mest")
      expect(user.learning_goal).to eq("i wanna be a senior RoR")
    end

    it "redirects to the user" do
      patch "/users/#{user.id}/profile", params: {user: valid_attributes}
      user.reload
      expect(response).to redirect_to(user_profile_url(user_id: user.id))
    end
  end
end
