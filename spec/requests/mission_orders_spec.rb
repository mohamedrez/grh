require "rails_helper"

RSpec.describe "/mission_orders", type: :request do
  let(:manager) { create(:user, admin: true) }
  let(:user) { create(:user, manager_id: manager.id, admin: true) }
  let(:site) { create(:site, id: 1) }
  let(:mission_order) { create(:mission_order, user_id: user.id, site_id: site.id, start_date: "2023-06-08", end_date: "2023-06-08",indemnity_type: "expense_report",) }

  let(:valid_attributes) do
    {
      title: "Presenting the App to the clients",
      start_date: "2023-06-08",
      end_date: "2023-06-09",
      indemnity_type: "expense_report",
      accommodation: "hotel",
      mission_type: "project",
      location: "Boston",
      transport_type: "plane",
      site_id: site.id,
      description: "<div>It's a mession order.</div>"
    }
  end

  let(:invalid_attributes) do
    {
      accommodation: "hotel",
      site_id: nil,
      description: "<div>It's a mession order.</div>"
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_mission_orders_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_mission_order_path(user_id: user.id, id: mission_order.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_mission_order_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_mission_order_path(user_id: user.id, id: mission_order.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new MissionOrder" do
        expect {
          post "/users/#{user.id}/mission_orders", params: {mission_order: valid_attributes}
        }.to change(MissionOrder, :count).by(1)
      end

      before do
        post "/users/#{user.id}/mission_orders", params: {mission_order: valid_attributes}
      end

      it "successfully creates mission_order" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("append")
        expect(response.body).to include("mission-order-list")
      end
    end

    context "with invalid parameters" do
      it "does not create a new MissionOrder" do
        expect {
          post "/users/#{user.id}/mission_orders", params: {mission_order: invalid_attributes}
        }.to change(MissionOrder, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{user.id}/mission_orders", params: {mission_order: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested mission_order" do
        patch "/users/#{user.id}/mission_orders/#{mission_order.id}", params: {mission_order: valid_attributes}
        mission_order.reload
        expect(mission_order.title).to eq("Presenting the App to the clients")
        expect(mission_order.start_date).to eq(Date.new(2023, 6, 8))
        expect(mission_order.end_date).to eq(Date.new(2023, 6, 9))
        expect(mission_order.indemnity_type).to eq("expense_report")
        expect(mission_order.accommodation).to eq("hotel")
        expect(mission_order.mission_type).to eq("project")
        expect(mission_order.location).to eq("Boston")
        expect(mission_order.transport_type).to eq("plane")
        expect(mission_order.site_id).to eq(site.id)
        expect(mission_order.description).to eq(MissionOrder.last.description)
      end

      before do
        patch "/users/#{user.id}/mission_orders/#{mission_order.id}", params: {mission_order: valid_attributes}
      end

      it "successfully updates mission_order" do
        mission_order.reload
        expect(response).to have_http_status(:ok)
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}/mission_orders/#{mission_order.id}", params: {mission_order: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete "/users/#{user.id}/mission_orders/#{mission_order.id}"
    end

    it "destroys the time off request" do
      expect(MissionOrder.count).to eq(0)
    end
    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_destroyed"))
    end
  end
end
