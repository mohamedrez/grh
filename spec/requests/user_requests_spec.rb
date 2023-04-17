require "rails_helper"

RSpec.describe "UserRequests", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:time_off_request) { create(:time_off_request, user_id: user.id, start_date: Date.today, end_date: (Date.today + 7)) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_user_requests_url(user_id: user.id)
      expect(response).to be_successful
    end
  end
end
