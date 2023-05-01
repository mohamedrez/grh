require "rails_helper"

RSpec.describe "Organizations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/organization"
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET /csv" do
    it "returns http success" do
      get "/organization/csv"
      expect(response).to have_http_status(:success)
    end
  end
end
