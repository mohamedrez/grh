require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:params) do
      {
        user: {
          first_name: "John",
          last_name: "Doe",
          address_attributes: {
            country: "ghana",
            street: "123 Main St",
            city: "New York",
            zipcode: "12345"
          }
        }
      }
    end
      it 'updates the user' do
        patch "/users/#{user.id}", params: params
        expect(user.reload.first_name).to eq("John")
        expect(user.reload.last_name).to eq("Doe")
        expect(user.reload.address.country).to eq("ghana")
        expect(user.reload.address.street).to eq("123 Main St")
        expect(user.reload.address.city).to eq("New York")

        params.update(user: { address_attributes: { country: "canada" } })
        put "/users/#{user.id}", params: params
        expect(user.reload.address.country).to eq("canada")
        expect(user.reload.address.street).to eq("123 Main St")
      end
  end
end
