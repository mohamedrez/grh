require "rails_helper"

RSpec.describe "/time_requests", type: :request do
  let(:manager) { create(:user, admin: true) }
  let(:user) { create(:user, manager_id: manager.id, admin: true) }
  let(:time_request) { create(:time_request, user_id: user.id) }

  let(:valid_attributes) do
    {
      start_date: "2023-04-01",
      end_date: "2023-04-06",
      content: "<div>I would like to take some time off to recharge and return to work feeling refreshed and more productive.</div>",
      category: "personal_time"
    }
  end

  let(:invalid_attributes) do
    {
      start_date: "2023-04-11",
      end_date: "2023-04-06"
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_time_requests_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_time_request_path(user_id: user.id, id: time_request.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_time_request_path(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_time_request_path(user_id: user.id, id: time_request.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new TimeRequest" do
        expect {
          post "/users/#{user.id}/time_requests", params: {time_request: valid_attributes}
        }.to change(TimeRequest, :count).by(1)
      end

      it "redirects to the created time_request" do
        post "/users/#{user.id}/time_requests", params: {time_request: valid_attributes}
        expect(response).to redirect_to(user_time_request_url(user, TimeRequest.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new TimeRequest" do
        expect {
          post "/users/#{user.id}/time_requests", params: {time_request: invalid_attributes}
        }.to change(TimeRequest, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{user.id}/time_requests", params: {time_request: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested time_request" do
        patch "/users/#{user.id}/time_requests/#{time_request.id}", params: {time_request: valid_attributes}
        time_request.reload
        expect(time_request.start_date).to eq(Date.new(2023, 0o4, 0o1))
        expect(time_request.end_date).to eq(Date.new(2023, 0o4, 0o6))
        expect(time_request.content).to eq(TimeRequest.last.content)
        expect(time_request.category).to eq("personal_time")
      end

      it "redirects to the time_request" do
        patch "/users/#{user.id}/time_requests/#{time_request.id}", params: {time_request: valid_attributes}
        time_request.reload
        expect(response).to redirect_to(user_time_request_url(user, time_request))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}/time_requests/#{time_request.id}", params: {time_request: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete "/users/#{user.id}/time_requests/#{time_request.id}"
    end

    it "destroys the time off request" do
      expect(TimeRequest.count).to eq(0)
    end
    it 'sets the flash notice' do
      expect(flash[:notice]).to eq(I18n.t("time_requests.time_request_destroyed"))
    end
  end
end
