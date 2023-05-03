require "rails_helper"

RSpec.describe TimeRequest, type: :model do
  let(:user) { create(:user) }
  let(:time_request) { create(:time_request, user_id: user.id, start_date: Date.today, end_date: (Date.today + 7)) }

  describe "#create_user_request" do
    it "creates a UserRequest object" do
      expect { time_request.create_user_request }.to change { UserRequest.count }.by(2)
    end

    it "associates the UserRequest object with the time request and user" do
      time_request.create_user_request
      expect(UserRequest.last.requestable).to eq(time_request)
      expect(UserRequest.last.user).to eq(user)
    end
  end

  describe "#overlapping_requests" do
    context "when there are no overlapping requests" do
      it "returns an empty array" do
        expect(time_request.overlapping_requests).to eq([])
      end
    end

    context "when there are overlapping requests" do
      it "returns a list of overlapping requests" do
        @user1 = create(:user)
        @user2 = create(:user)

        @time_request1 = create(:time_request, user_id: @user1.id, start_date: (Date.today - 4), end_date: (Date.today + 3))
        @time_request2 = create(:time_request, user_id: @user2.id, start_date: (Date.today + 2), end_date: (Date.today + 9))

        expect(time_request.overlapping_requests).to eq([@time_request2])
      end
    end
  end
end
