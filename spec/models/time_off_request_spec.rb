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

  describe "#who_else_be_out?" do
    context "when there are no overlapping requests" do

      it "returns an empty array" do
        expect(time_off_request.who_else_be_out?).to eq([])
      end
    end

    context "when there are overlapping requests" do

      it "returns a list of overlapping requests with users" do
        expected_result = [
          {user: user1, request: time_off_request1},
          {user: user2, request: time_off_request2}
        ]
        expect(time_off_request.who_else_be_out?).to eq(expected_result)
      end
    end
  end

  describe '#day_color' do
    context "when day is in the range of the time off request" do
      it "returns the expected class for the current day" do
        expect(time_off_request.day_color(Date.today.day)).to eq("font-semibold bg-gray-900 text-indigo-600")
      end
  
      it "returns the expected class for a day within the range" do
        expect(time_off_request.day_color(Date.today.day + 7)).to eq("bg-gray-900 font-semibold text-white")
      end
    end
  
    context "when day is outside the range of the time off request" do
      it "returns the expected class for a day before the range" do
        expect(time_off_request.day_color(Date.today.day - 1)).to eq("text-gray-900 hover:bg-gray-200")
      end
  
      it "returns the expected class for a day after the range" do
        expect(time_off_request.day_color(Date.today.day + 8)).to eq("text-gray-900 hover:bg-gray-200")
      end
    end
  end

end
