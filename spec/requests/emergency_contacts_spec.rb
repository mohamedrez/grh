require 'rails_helper'

RSpec.describe "/emergency_contacts", type: :request do
  let(:admin_user) { create(:user, admin: true) }
  let(:emergency_contact) { create(:emergency_contact, user_id: admin_user.id) }
  
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
    sign_in admin_user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get user_emergency_contacts_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_emergency_contact_url(user_id: admin_user.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_user_emergency_contact_url(user_id: admin_user.id, id: emergency_contact.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new EmergencyContact" do
        expect {
          post "/users/#{admin_user.id}/emergency_contacts", params: { emergency_contact: valid_attributes }
        }.to change(EmergencyContact, :count).by(1)
      end

      it "redirects to the emergency_contacts list" do
        post "/users/#{admin_user.id}/emergency_contacts", params: { emergency_contact: valid_attributes }
        expect(response).to redirect_to(user_emergency_contacts_url(user_id: admin_user.id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new EmergencyContact" do
        expect {
          post "/users/#{admin_user.id}/emergency_contacts", params: { emergency_contact: invalid_attributes }
        }.to change(EmergencyContact, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post "/users/#{admin_user.id}/emergency_contacts", params: { emergency_contact: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested emergency_contact" do
        patch "/users/#{admin_user.id}/emergency_contacts/#{emergency_contact.id}", params: { emergency_contact: valid_attributes }
        emergency_contact.reload
        expect(emergency_contact.name).to eq("James Clear")
        expect(emergency_contact.relationship).to eq("brother")
        expect(emergency_contact.phone).to eq("111-454-7845")
        expect(emergency_contact.email).to eq("james@gmail.com")
      end

      it "redirects to the emergency_contacts list" do
        patch "/users/#{admin_user.id}/emergency_contacts/#{emergency_contact.id}", params: { emergency_contact: valid_attributes }
        emergency_contact.reload
        expect(response).to redirect_to(user_emergency_contacts_url(user_id: admin_user.id))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch "/users/#{admin_user.id}/emergency_contacts/#{emergency_contact.id}", params: { emergency_contact: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
