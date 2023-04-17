require "rails_helper"

RSpec.describe TimeOffRequest, type: :model do
  let(:user) { create(:user) }
  let(:time_off_request) { create(:time_off_request, user_id: user.id, start_date: Date.today, end_date: (Date.today + 7)) }

  let(:user1) { create(:user) }
  let(:time_off_request1) { create(:time_off_request, user_id: user1.id, start_date: (Date.today - 4), end_date: (Date.today + 3)) }

  let(:user2) { create(:user) }
  let(:time_off_request2) { create(:time_off_request, user_id: user2.id, start_date: (Date.today + 2), end_date: (Date.today + 9)) }

  describe "#create_user_request" do
    it "creates a UserRequest object" do
      expect { time_off_request.create_user_request }.to change { UserRequest.count }.by(2)
    end

    it "associates the UserRequest object with the time off request and user" do
      time_off_request.create_user_request
      expect(UserRequest.last.requestable).to eq(time_off_request)
      expect(UserRequest.last.user).to eq(user)
    end
  end

  describe "#find_overlapping_requests" do
    context "when there are no overlapping requests" do

      it "returns an empty array" do
        expect(time_off_request.find_overlapping_requests).to eq([])
      end
    end

    context "when there are overlapping requests" do

      it "returns a list of overlapping requests with users" do
        expected_result = [
          {user: user1, request: time_off_request1},
          {user: user2, request: time_off_request2}
        ]
        expect(time_off_request.find_overlapping_requests).to eq(expected_result)
      end
    end
  end
end
