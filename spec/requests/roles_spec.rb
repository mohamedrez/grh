require 'rails_helper'

RSpec.describe "Roles", type: :request do
  let(:user) { create(:user) } 
  let(:role) { create(:role, user_id: user.id) }

  let(:valid_attributes) do
    {
      name: "hr",
      user_id: user.id
    }
  end
  
  let(:invalid_attributes) do
    {
      name: nil,
      user_id: user.id
    }
  end

  before do
    Role.create!(user_id: user.id, name: :admin)
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get roles_path
      expect(response).to be_successful 
    end
  end

  describe "GET /new" do
    it "renders a successful reponse" do
      get new_role_path
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do 
    it "renders a successful reponse" do
      get edit_role_path(id: role.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "When the role is succesfully created" do
      before do
        post roles_path, params: {role: valid_attributes}
      end

      it 'creates a new role' do
        expect(Role.count).to eq(2)
      end

      it 'renders the Turbo Stream response' do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("append")
        expect(response.body).to include("role-list")
      end
    end

    context 'when the role fails to save' do
      before do
        post roles_path, params: {role: invalid_attributes}
      end

      it 'does not create a new role' do
        expect(Role.count).to eq(1)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    before do 
      patch role_path(id: role.id), params: {role: valid_attributes}
    end

    context 'with valid parameters' do
      it 'updates the requested role' do 
        role.reload
        expect(role.name).to eq("hr")
        expect(role.user_id).to eq(user.id)
      end

      it 'successfully updates role' do
        expect(response).to have_http_status(:ok)
      end

      it "renders the Turbo Stream response" do
        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream")
        expect(response.body).to include("replace")
      end
    end

    context 'when the role fails to update' do
      before do
        patch role_path(id: role.id), params: {role: invalid_attributes}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /desttroy' do
    before do
      delete role_path(id: role.id)
    end
    
    it 'destroy the role' do
      expect(Role.count).to eq(1)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
    end
  end
end
