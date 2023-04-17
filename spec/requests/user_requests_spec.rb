require "rails_helper"

RSpec.describe "UserRequests", type: :request do
  let(:admin_user) { create(:user, admin: true) }
  let(:user) { create(:user) }
  let(:time_off_request) { create(:time_off_request, user_id: admin_user.id, start_date: Date.today, end_date: (Date.today + 7)) }

  before do
    sign_in admin_user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_user_requests_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "PATCH /user_requests/:id" do
    context "when the request is approved" do
      before do
        patch user_user_request_update_path(user_id: user.id, id: time_off_request.user_request.id, managed_by_id: admin_user.id, state: "approved")
      end

      it "updates the request with the correct attributes" do
        time_off_request.user_request.reload
        expect(time_off_request.user_request.state).to eq("approved")
        expect(time_off_request.user_request.managed_by_id).to eq(admin_user.id)
      end

      it "redirects to the user time off request page" do
        expect(response).to redirect_to(user_time_off_request_path(user_id: user.id, id: time_off_request.id))
      end
    end

    context "when the request is rejected" do
      before do
        patch user_user_request_update_path(user_id: user.id, id: time_off_request.user_request.id, managed_by_id: user.id, state: "rejected")
      end

      it "updates the request with the correct attributes" do
        time_off_request.user_request.reload
        expect(time_off_request.user_request.state).to eq("rejected")
        expect(time_off_request.user_request.managed_by_id).to eq(user.id)
      end

      it "redirects to the user time off request page" do
        expect(response).to redirect_to(user_time_off_request_path(user_id: user.id, id: time_off_request.id))
      end
    end
  end
end
