require 'rails_helper'

RSpec.describe "/goals", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:goal) { create(:goal, owner_id: user.id, author_id: user.id) }

  let(:valid_attributes) do
    {
      title: "Mastering Hotwire",
      owner_id: user.id,
      start_date: Date.new(2023, 05, 25),
      due_date: Date.new(2024, 05, 25),
      level: :very_important,
      author_id: user.id
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      owner_id: user.id,
      start_date: nil,
      due_date: nil,
      level: nil,
      author_id: user.id
    }
  end

  before do
    sign_in user
    Role.create!(user_id: user.id, name: :manager)
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
      context "from index page" do
        before do
          patch "/goals/#{goal.id}", params: {from_view: "index", goal: valid_attributes}
        end

        it "updates the goal" do
          goal.reload
          expect(goal.title).to eq("Mastering Hotwire")
          expect(goal.owner_id).to eq(user.id)
          expect(goal.level).to eq("very_important")
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

      context "from show page" do
        before do
          patch "/goals/#{goal.id}", params: {from_view: "show", goal: valid_attributes}
        end

        it "updates the goal" do
          goal.reload
          expect(goal.title).to eq("Mastering Hotwire")
          expect(goal.owner_id).to eq(user.id)
          expect(goal.level).to eq("very_important")
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

  describe "PATCH /end_goal" do
    context "submitting the end_goal_form with valid parameters" do
      before do
        patch "/goals/#{goal.id}/end_goal", params: { goal: { end_goal_description: "The goal was fully ended", status: "completed" } }
      end

      it "returns a 302 response" do
        expect(response).to have_http_status 302
      end

      it "updates the attributes for the end_goal_form" do
        goal.reload
        expect(goal.end_goal_description).to eq("The goal was fully ended")
        expect(goal.status).to eq("completed")
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.goal_successfully_ended"))
      end

      it "redirects to the goal" do
        expect(response).to redirect_to goal_path(goal)
      end
    end

    context "submitting the end_goal_form with invalid parameters" do
      context "without end_goal_description && status" do
        before do
          patch end_goal_path(id: goal.id), params: { goal: { end_goal_description: nil, status: nil } }
        end

        it "returns a 302 response" do
          expect(response).to have_http_status 302
        end

        it "does not update the attributes for the end_goal_form" do
          goal.reload
          expect(goal.end_goal_description).to eq(nil)
          expect(goal.status).to eq(nil)
        end

        it "redirects to the goal" do
          end_goal_errors = { end_goal_description: I18n.t("errors.end_goal_description"), status: I18n.t("errors.should_provide_status") }
          expect(response).to redirect_to goal_path(goal, end_goal_errors: end_goal_errors, end_goal_description: nil, status: nil)
        end
      end

      context "submitting the end_goal_form with status and without end_goal_description" do
        before do
          patch "/goals/#{goal.id}/end_goal", params: { goal: { end_goal_description: nil, status: :completed } }
        end

        it "returns a 302 response" do
          expect(response).to have_http_status 302
        end

        it "does not update the attributes for the end_goal_form" do
          goal.reload
          expect(goal.end_goal_description).to eq(nil)
          expect(goal.status).to eq(nil)
        end

        it "redirects to the goal" do
          end_goal_errors = { end_goal_description: I18n.t("errors.end_goal_description") }
          expect(response).to redirect_to goal_path(goal, end_goal_errors: end_goal_errors, end_goal_description: nil, status: "completed")
        end
      end

      context "submitting the end_goal_form with end_goal_description and without status" do
        before do
          patch "/goals/#{goal.id}/end_goal", params: { goal: { end_goal_description: "The goal was ended fully", status: nil } }
        end

        it "returns a 302 response" do
          expect(response).to have_http_status 302
        end

        it "does not update the attributes for the end_goal_form" do
          goal.reload
          expect(goal.end_goal_description).to eq(nil)
          expect(goal.status).to eq(nil)
        end

        it "redirects to the goal" do
          end_goal_errors = { status: I18n.t("errors.should_provide_status") }
          expect(response).to redirect_to goal_path(goal, end_goal_errors: end_goal_errors, end_goal_description: "The goal was ended fully", status: nil)
        end
      end
    end
  end

  describe "PATCH /archive" do
    context "from index page" do
      before do
        patch archive_goal_url(id: goal.id, from_view: "index")
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "archived the goal" do
        goal.reload
        expect(goal.archived).to eq(true)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_archived"))
      end

      it "renders the Turbo Stream response" do
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("remove")
      end
    end
    context "from show page" do
      before do
        patch archive_goal_url(id: goal.id, from_view: "show")
      end

      it "returns a 302 response" do
        expect(response).to have_http_status 302
      end

      it "archived the goal" do
        goal.reload
        expect(goal.archived).to eq(true)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_archived"))
      end

      it "redirects to the goals" do
        expect(response).to redirect_to goals_path
      end
    end
  end
  describe "GET /objectives" do
    it "returns a successful response" do
      user
      create :goal, owner_id: user.id, status: "completed", level: "critical"
      create :goal, owner_id: user.id, status: "overpassed", level: "important"
      create :goal, owner_id: user.id, status: "partially_achieved", level: "very_important"
      get "/objectives?user_id=#{user.id},year=#{Date.today.year}"
      expect(response).to have_http_status(:ok)
    end
  end
end
