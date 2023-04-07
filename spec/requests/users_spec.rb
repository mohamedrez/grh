require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /users/:id/edit" do
    it "renders a successful response" do
      get "/users/#{user.id}/edit"
      expect(response).to be_successful
    end
  end

  describe "PATCH /users/:id" do
    let(:params) do
      {
        user: {
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
          address_attributes: {
            street: "123 Main St",
            country: "usa",
            city: "New York",
            zipcode: "42157"
          }
        }
      }
    end
    it 'updates the user' do
      patch "/users/#{user.id}", params: params
      expect(user.reload.first_name).to eq("John")
      expect(user.reload.last_name).to eq("Doe")
      expect(user.reload.about).to eq(user.about)
      expect(user.reload.phone).to eq("12345678")
      expect(user.reload.birthdate).to eq(Date.new(1998, 03, 02))
      expect(user.reload.gender).to eq("male")
      expect(user.reload.marital_status).to eq("single")
      expect(user.reload.job_title).to eq("RoR developer")
      expect(user.reload.start_date).to eq(Date.new(2019, 03, 02))
      expect(user.reload.end_date).to eq(Date.new(2024, 03, 02))

      expect(user.reload.address.street).to eq("123 Main St")
      expect(user.reload.address.country).to eq("usa")
      expect(user.reload.address.city).to eq("New York")
      expect(user.reload.address.zipcode).to eq("42157")

      params.update(user: { address_attributes: { country: "canada" } })
      put "/users/#{user.id}", params: params
      expect(user.reload.address.country).to eq("canada")
      expect(user.reload.address.street).to eq("123 Main St")
    end
  end
end
