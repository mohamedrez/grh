require 'rails_helper'

RSpec.describe "/goals", type: :request do
  let(:owner) { create(:user, admin: true) }
  let(:goal) { create(:goal, owner_id: owner.id) }

  let(:valid_attributes) do
    {
      title: "Mastering Hotwire",
      owner_id: owner.id,
      start_date: Date.new(2023, 05, 25),
      due_date: Date.new(2024, 05, 25)
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      owner_id: owner.id,
      start_date: nil,
      due_date: nil
    }
  end

  before do
    sign_in owner
  end

  describe "GET /index" do
    it "renders a successful response" do
      get goals_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get goal_url(id: goal.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_goal_url(id: goal.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_goal_url(id: goal.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      before do
        post "/goals", params: {goal: valid_attributes}
      end

      it "creates a new goal" do
        expect(Goal.count).to eq(1)
      end

      it "successfully creates time_request" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("append")
        expect(response.body).to include("goal-list")
      end
    end

    context "with invalid parameters" do
      before do
        post "/goals", params: {goal: invalid_attributes}
      end

      it "does not create a new goal" do
        expect(Goal.count).to eq(0)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch "/goals/#{goal.id}", params: {goal: valid_attributes}
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the goal" do
        goal.reload
        expect(goal.title).to eq("Mastering Hotwire")
        expect(goal.owner_id).to eq(owner.id)
        expect(goal.start_date).to eq(Date.new(2023, 05, 25))
        expect(goal.due_date).to eq(Date.new(2024, 05, 25))
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end
    end

    context "with invalid parameters" do
      before do
        patch "/goals/#{goal.id}", params: {goal: invalid_attributes}
      end

      it "returns an unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete "/goals/#{goal.id}"
    end

    it "destroys the goal" do
      expect(Goal.count).to eq(0)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("flash.successfully_destroyed"))
    end
  end
end
