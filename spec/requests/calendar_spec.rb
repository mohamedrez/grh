require 'rails_helper'

RSpec.describe "Calendars", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/calendar"
      expect(response).to have_http_status(:success)
    end
  end
end
