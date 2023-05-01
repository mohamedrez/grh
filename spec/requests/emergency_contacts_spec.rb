require "rails_helper"

RSpec.describe "/emergency_contacts", type: :request do
  let(:user) { create(:user, admin: true) }
  let(:emergency_contact) { create(:emergency_contact, user_id: user.id) }

  let(:valid_attributes) do
    {
      name: "James Clear",
      relationship: :brother,
      phone: "111-454-7845",
      email: "james@gmail.com"
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      relationship: :brother,
      phone: "",
      email: "james@gmail.com"
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_emergency_contacts_url(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_emergency_contact_url(user_id: user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_emergency_contact_url(user_id: user.id, id: emergency_contact.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context 'when the emergency contact is successfully created' do
      before do
        post "/users/#{user.id}/emergency_contacts", params: {emergency_contact: valid_attributes}
      end

      it 'creates a new emergency contact' do
        expect(EmergencyContact.count).to eq(1)
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq('Emergency contact successfully created.')
      end
    end

    context 'when the emergency contact fails to save' do
      before do
        post "/users/#{user.id}/emergency_contacts", params: {emergency_contact: invalid_attributes}
      end

      it 'does not create a new emergency contact' do
        expect(EmergencyContact.count).to eq(0)
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context 'when the emergency contact is successfully updated' do
      before do
        patch "/users/#{user.id}/emergency_contacts/#{emergency_contact.id}", params: {emergency_contact: valid_attributes}
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it "updates the requested emergency_contact" do
        emergency_contact.reload
        expect(emergency_contact.name).to eq("James Clear")
        expect(emergency_contact.relationship).to eq("brother")
        expect(emergency_contact.phone).to eq("111-454-7845")
        expect(emergency_contact.email).to eq("james@gmail.com")
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
    end

    context 'when the emergency contact fails to update' do
      before do
        patch "/users/#{user.id}/emergency_contacts/#{emergency_contact.id}", params: {emergency_contact: invalid_attributes}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      delete "/users/#{user.id}/emergency_contacts/#{emergency_contact.id}"
    end

    it 'destroys the emergency contact' do
      expect(EmergencyContact.count).to eq(0)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq('emergency contact was successfully destroyed.')
    end
  end
end
