require 'rails_helper'

RSpec.describe "/assets", type: :request do
  let(:admin_user) { create(:user, admin: true) }
  let(:asset) { create(:asset, user_id: admin_user.id) }
  
  let(:valid_attributes) do
    {
      category: :computers,
      description: "Dell Latitude E7450 Laptop, Intel Core i5, 8GB RAM, 256GB SSD, Windows 10 Pro",
      serial: "#12345678",
      date_assigned: "2022-04-27",
      date_returned: "2023-04-27"
    }
  end

  let(:invalid_attributes) do
    {
      description: "Dell Latitude E7450 Laptop, Intel Core i5, 8GB RAM, 256GB SSD, Windows 10 Pro",
      serial: "",
      date_assigned: "",
      date_returned: ""
    }
  end

  before do
    sign_in admin_user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_assets_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_asset_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_asset_url(user_id: admin_user.id, id: asset.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Asset" do
        expect {
          post "/users/#{admin_user.id}/assets", params: { asset: valid_attributes }
        }.to change(Asset, :count).by(1)
      end

      it "redirects to the assets list" do
        post "/users/#{admin_user.id}/assets", params: { asset: valid_attributes }
        expect(response).to redirect_to(user_assets_url(user_id: admin_user.id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Asset" do
        expect {
          post "/users/#{admin_user.id}/assets", params: { asset: invalid_attributes }
        }.to change(Asset, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{admin_user.id}/assets", params: { asset: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested asset" do
        patch "/users/#{admin_user.id}/assets/#{asset.id}", params: { asset: valid_attributes }
        asset.reload
        expect(asset.category).to eq("computers")
        expect(asset.description).to eq("Dell Latitude E7450 Laptop, Intel Core i5, 8GB RAM, 256GB SSD, Windows 10 Pro")
        expect(asset.serial).to eq("#12345678")
        expect(asset.date_assigned).to eq(Date.new(2022, 4, 27))
        expect(asset.date_returned).to eq(Date.new(2023, 4, 27))

      end

      it "redirects to the assets list" do
        patch "/users/#{admin_user.id}/assets/#{asset.id}", params: { asset: valid_attributes }
        asset.reload
        expect(response).to redirect_to(user_assets_url(user_id: admin_user.id))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{admin_user.id}/assets/#{asset.id}", params: { asset: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
