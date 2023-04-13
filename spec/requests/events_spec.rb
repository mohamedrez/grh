require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /index" do

    it "returns http success" do
      create :event
      create :event
      get "/events"
      expect(response).to have_http_status(:success)
      debugger
    end
  end
end
