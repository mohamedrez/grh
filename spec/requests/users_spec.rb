require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, admin: true) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get "/users/#{user.id}"
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get "/users/#{user.id}/edit"
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:valid_attributes) do
        {
          first_name: "John",
          last_name: "Doe",
          about: "<div>hello everyone</div>",
          phone: "12345678",
          birthdate: "02-03-1998",
          gender: "male",
          marital_status: "single",
          job_title: "RoR developer",
          start_date: "02-03-2019",
          end_date: "02-03-2024",
          address_attributes:
            {
              street: "123 Main St",
              country: "usa",
              city: "New York",
              zipcode: "42157"
            }
        }
      end

      it "updates the requested user" do
        patch "/users/#{user.id}", params: {user: valid_attributes}
        user.reload

        expect(user.first_name).to eq("John")
        expect(user.last_name).to eq("Doe")
        expect(user.about).to eq(user.about)
        expect(user.phone).to eq("12345678")
        expect(user.gender).to eq("male")
        expect(user.marital_status).to eq("single")
        expect(user.job_title).to eq("RoR developer")
        expect(user.start_date).to eq(Date.new(2019, 0o3, 0o2))
        expect(user.birthdate).to eq(Date.new(1998, 0o3, 0o2))
        expect(user.end_date).to eq(Date.new(2024, 0o3, 0o2))

        expect(user.address.street).to eq("123 Main St")
        expect(user.address.country).to eq("usa")
        expect(user.address.city).to eq("New York")
        expect(user.address.zipcode).to eq("42157")
      end

      it "redirects to the user" do
        patch "/users/#{user.id}", params: {user: valid_attributes}
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          first_name: "",
          last_name: "Doe"
        }
      end

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{user.id}", params: {user: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
