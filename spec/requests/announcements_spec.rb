require 'rails_helper'

RSpec.describe "Announcements", type: :request do
  let(:user) { create(:user) } 
  let(:announcement) { create(:announcement, user_id: user.id) }

  let(:valid_attributes) do
    {
      title: 'New Title',
      status: 'published',
      published_at: '2023-05-04',
    }
  end
  
  let(:invalid_attributes) do
    {
      title: "",
      published_at: ''
    }
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get announcements_path
      expect(response).to be_successful 
    end
  end

  describe "GET /show" do
    it "renders a successful reponse" do
      get announcement_url(id: announcement.id)
      expect(response).to be_successful
    end  
  end

  describe "GET /new" do
    it "renders a successful reponse" do
      get new_announcement_path(id: announcement.id)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do 
    it "renders a successful reponse" do
      get edit_announcement_path(id: announcement.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "When the announcement is succesfully created" do
      before do
        post "/announcements", params: {announcement: valid_attributes}
      end

      it 'creates a new announcement' do
        expect(Announcement.count).to eq(1)
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:found)
      end

      it 'sets the flash notice' do
        expect(flash[:notice]).to eq( I18n.t("flash.successfully_created"))
      end
    end

    context 'when the emergency contact fails to save' do
      before do
        post "/announcements", params: {announcement: invalid_attributes}
      end

      it 'does not create a new announcement' do
        expect(Announcement.count).to eq(0)
      end

      it 'returns an unprocessable entity status' do
        expect(response)
      end
    end
  end 

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'updates the requested announcement' do 
        patch announcement_url(id: announcement.id), params: {announcement: valid_attributes}
        announcement.reload
        expect(announcement.title).to eq("New Title")
        expect(announcement.status).to eq("published")
        expect(announcement.published_at).to eq(Date.new(2023, 05, 04))
      end

      it 'redirects to the announcement' do
        patch announcement_path(id: announcement.id), params: {announcement: valid_attributes}
        announcement.reload
        expect(@response).to redirect_to(announcements_path)  
      end
    end

    context 'when the announcement fails to update' do
      before do
        patch "/announcements/#{announcement.id}", params: {announcement: invalid_attributes}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /desttroy' do
    before do
      delete announcement_path(id: announcement.id)
    end
    
    it 'destroy the announcement' do
      expect(Announcement.count).to eq(0)
    end

    it 'sets the flash notice' do
      expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
    end
  end
end
