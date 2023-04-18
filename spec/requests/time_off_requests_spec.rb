require "rails_helper"

RSpec.describe "/time_off_requests", type: :request do
  let(:admin_user) { create(:user, admin: true) }
  let(:time_off_request) { create(:time_off_request, user_id: admin_user.id) }

  let(:valid_attributes) do
    {
      start_date: "2023-04-01", 
      end_date: "2023-04-06",
      content: "<div>I would like to take some time off to recharge and return to work feeling refreshed and more productive.</div>"
    }
  end

  let(:invalid_attributes) do
    {
      start_date: "2023-04-11", 
      end_date: "2023-04-06"
    }
  end

  before do
    sign_in admin_user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_time_off_requests_path(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_time_off_request_path(user_id: admin_user.id, id: time_off_request.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_time_off_request_path(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_time_off_request_path(user_id: admin_user.id, id: time_off_request.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new TimeOffRequest" do
        expect {
          post "/users/#{admin_user.id}/time_off_requests", params: {time_off_request: valid_attributes}
        }.to change(TimeOffRequest, :count).by(1)
      end

      it "redirects to the created time_off_request" do
        post "/users/#{admin_user.id}/time_off_requests", params: {time_off_request: valid_attributes}
        expect(response).to redirect_to(user_time_off_request_url(admin_user, TimeOffRequest.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new TimeOffRequest" do
        expect {
          post "/users/#{admin_user.id}/time_off_requests", params: {time_off_request: invalid_attributes}
        }.to change(TimeOffRequest, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{admin_user.id}/time_off_requests", params: {time_off_request: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


    ##############################################################################
    ##############################################################################


  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested time_off_request" do
        patch "/users/#{admin_user.id}/time_off_requests/#{time_off_request.id}", params: {time_off_request: valid_attributes}
        time_off_request.reload
        expect(time_off_request.start_date).to eq(Date.new(2023, 04, 01))
        expect(time_off_request.end_date).to eq(Date.new(2023, 04, 06))
        expect(time_off_request.content).to eq(TimeOffRequest.last.content)
      end

      it "redirects to the time_off_request" do
        patch "/users/#{admin_user.id}/time_off_requests/#{time_off_request.id}", params: {time_off_request: valid_attributes}
        time_off_request.reload
        expect(response).to redirect_to(user_time_off_request_url(admin_user, time_off_request))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{admin_user.id}/time_off_requests/#{time_off_request.id}", params: {time_off_request: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end



  ##############################################################################
  ##############################################################################

  describe "DELETE /destroy" do
    xit "destroys the requested time_off_request" do
      time_off_request = TimeOffRequest.create! valid_attributes
      expect {
        delete user_time_off_request_url(time_off_request)
      }.to change(TimeOffRequest, :count).by(-1)
    end

    xit "redirects to the time_off_requests list" do
      time_off_request = TimeOffRequest.create! valid_attributes
      delete user_time_off_request_url(time_off_request)
      expect(response).to redirect_to(time_off_requests_url)
    end
  end
end
