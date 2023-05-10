require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      create :event
      create :event
      get "/events"
      expect(response).to have_http_status(:success)
    end
  end
end
