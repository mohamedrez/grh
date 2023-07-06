require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:manager) { create(:user, admin: true) }
  let(:user) { create(:user, manager_id: manager.id, admin: true) }

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

  describe "#time_requests" do
    let!(:time_request) { create(:time_request) } # Assuming you have a TimeRequest factory set up
    let!(:user_request) { create(:user_request, user_id: user.id, requestable: time_request) }
  
    it "fetches and formats time requests" do
      allow(TimeRequest).to receive(:all).and_return(TimeRequest.all.includes(:user_request).includes(user_request: :user))
  
      get "/events"
  
      expect(JSON.parse(response.body, symbolize_names: true)).to eq([
        {
          id: time_request.id,
          type: "Time request",
          title: time_request.user.full_name,
          start: time_request.start_date.to_fs(:db),
          end: time_request.end_date.to_fs(:db),
          avatar: time_request.user.avatar_url_or_default,
          color: time_request.color
        }
      ])
    end
  end

  describe "#mission_orders" do
    let(:site) { create(:site, id: 1) }
    let(:mission_order) { create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08",indemnity_type: "expense_report") }
    let!(:user_request) { create(:user_request, user_id: user.id, requestable: mission_order) }
  
    it "fetches and formats time requests" do
      allow(MissionOrder).to receive(:all).and_return(MissionOrder.all.includes(:user_request).includes(user_request: :user))
  
      get "/events"
  
      expect(JSON.parse(response.body, symbolize_names: true)).to eq([
        {
          id: mission_order.id,
          type: "Mission order",
          title: mission_order.user.full_name,
          start: mission_order.start_date.to_fs(:db),
          end: mission_order.end_date.to_fs(:db),
          avatar: mission_order.user.avatar_url_or_default
        }
      ])
    end
  end

  describe "#expenses" do
    let!(:expense) { create(:expense) } # Assuming you have a Expense factory set up
    let!(:user_request) { create(:user_request, user_id: user.id, requestable: expense) }
  
    it "fetches and formats time requests" do
      allow(Expense).to receive(:all).and_return(Expense.all.includes(:user_request).includes(user_request: :user))
  
      get "/events"
  
      expect(JSON.parse(response.body, symbolize_names: true)).to eq([
        {
          id: expense.id,
          type: "Expense",
          title: expense.user.full_name,
          date: expense.date.to_fs(:db),
          avatar: expense.user.avatar_url_or_default
        }
      ])
    end
  end
end
