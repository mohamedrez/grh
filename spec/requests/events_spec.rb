require "rails_helper"

RSpec.describe "Events", type: :request do
  describe "GET /index" do
    it "returns http success" do
      create :holiday
      site = create :site, name: "Site 1"
      user = create :user, service: :financial, site_id: site.id
      time_request = create :time_request
      user_request = create :user_request, user_id: user.id, requestable: time_request
      get "/events?service=financial&site=1"
      expect(response).to have_http_status(:success)
    end
  end
end
