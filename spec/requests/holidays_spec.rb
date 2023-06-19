require "rails_helper"

RSpec.describe "/holidays", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:holiday) { create(:holiday) }

  let(:valid_attributes) do
    {
      name: "Summer Holiday",
      start_date: "2023-04-01",
      end_date: "2023-04-06"
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      start_date: "2023-04-11",
      end_date: "2023-04-06"
    }
  end

  before do
    Role.create!(user_id: user.id, name: :admin)
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get holidays_path
      expect(response).to be_successful
    end

    it "assigns @holidays ordered by start date" do
      holiday1 = create(:holiday, start_date: Date.today, end_date: Date.today + 2)
      holiday2 = create(:holiday, start_date: Date.tomorrow, end_date: Date.tomorrow + 2)
      get holidays_path
      expect(response.body).to include(holiday1.start_date.to_s)
      expect(response.body).to include(holiday2.start_date.to_s)
      expect(response.body.index(holiday1.start_date.to_s)).to be < response.body.index(holiday2.start_date.to_s)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_holiday_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_holiday_url(id: holiday.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Holiday" do
        expect {
          post holidays_url, params: {holiday: valid_attributes}
        }.to change(Holiday, :count).by(1)
      end

      before do
        post holidays_url, params: {holiday: valid_attributes}
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("prepend")
        expect(response.body).to include("holidays")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Holiday" do
        expect {
          post holidays_url, params: {holiday: invalid_attributes}
        }.to change(Holiday, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post holidays_url, params: {holiday: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        patch holiday_url(id: holiday.id), params: {holiday: valid_attributes}
      end

      it "updates the requested holiday" do
        holiday.reload
        expect(holiday.name).to eq("Summer Holiday")
        expect(holiday.start_date).to eq(Date.new(2023, 0o4, 0o1))
        expect(holiday.end_date).to eq(Date.new(2023, 0o4, 0o6))
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end

      it "sets a success flash message" do
        expect(flash[:notice]).to eq(I18n.t("flash.successfully_updated"))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch holiday_url(id: holiday.id), params: {holiday: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE /destroy' do
      before do
        delete holiday_path(id: holiday.id)
      end
      
      it 'destroy the holiday' do
        expect(Holiday.count).to eq(0)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
      end
    end
  end
end
