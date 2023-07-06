require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "#index" do
    let(:holidays) { [{ id: 1, type: "Holiday", title: "New Year's Day" }] } # Example holidays data
    let(:time_requests) { [{ id: 2, type: "Time request", title: "John Doe" }] } # Example time requests data
    let(:mission_orders) { [{ id: 3, type: "Mission order", title: "Jane Smith" }] } # Example mission orders data
    let(:expenses) { [{ id: 4, type: "Expense", title: "Business Dinner" }] } # Example expenses data
    
    it "returns an array of events" do
      allow(controller).to receive(:holidays).and_return(holidays) # Stubbing the holidays method
      allow(controller).to receive(:time_requests).and_return(time_requests) # Stubbing the time_requests method
      allow(controller).to receive(:mission_orders).and_return(mission_orders) # Stubbing the mission_orders method
      allow(controller).to receive(:expenses).and_return(expenses) # Stubbing the expenses method

      get "/events"
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)

    end
  end
end
