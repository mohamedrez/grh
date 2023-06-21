require "rails_helper"

RSpec.describe TimeRequest, type: :model do
  let(:manager) { create(:user, admin: true) }
  let(:user) { create(:user, manager_id: manager.id, admin: true) }
  let(:time_request) { create(:time_request, user_id: user.id, start_date: "2023-06-21", end_date: "2023-06-28") }

  describe "#color" do
    it "returns the correct color for each category" do
      request = TimeRequest.new(category: :vacation_time)
      expect(request.color).to eq("#FFD700")

      request = TimeRequest.new(category: :sick_time)
      expect(request.color).to eq("#FF0000")

      request = TimeRequest.new(category: :personal_time)
      expect(request.color).to eq("#00FF00")

      request = TimeRequest.new(category: :bereavement_time)
      expect(request.color).to eq("#0000FF")

      request = TimeRequest.new(category: :parental_leave)
      expect(request.color).to eq("#FF00FF")
    end
  end
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
        @user1 = create(:user, manager_id: manager.id)
        @user2 = create(:user, manager_id: manager.id)

        @time_request1 = create(:time_request, user_id: @user1.id, start_date: "2023-06-17", end_date: "2023-06-24")
        @time_request2 = create(:time_request, user_id: @user2.id, start_date: "2023-06-23", end_date: "2023-06-30")

        expect(time_request.overlapping_requests).to eq([@time_request2])
      end
    end
  end

  describe "#subtract_pto" do
    it "subtracts the pto_number of the user" do
      expect(time_request.subtract_pto).to eq(15)
    end
  end
end
